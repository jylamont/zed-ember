use std::collections::HashMap;
use std::fs;
use zed_extension_api::{self as zed, Result};

use zed::lsp::{Completion, CompletionKind};
use zed::CodeLabelSpan;

pub struct EmberServer {
    pub did_find_server: bool,
}

const SERVER_PATH: &str =
    "node_modules/@ember-tooling/ember-language-server/bin/ember-language-server.js";

impl EmberServer {
    fn server_exists(&self) -> bool {
        fs::metadata(SERVER_PATH).map_or(false, |stat| stat.is_file())
    }

    pub fn server_script_path(&mut self, id: &zed::LanguageServerId) -> Result<String> {
        let node_dependencies: HashMap<&str, &str> = [
            ("@ember-tooling/ember-language-server", "2.30.5"),
            ("els-a11y-addon", "1.0.4"),
            // TODO: FIGURE OUT HOW TO REGISTER COMMANDS FOR EMBER FAST CLI
            ("ember-fast-cli", "1.3.1"),
            ("ember-cli", "*"),
            // TODO: Revisit adding glint dependencies when the glint language server is implemented.
        ]
        .iter()
        .cloned()
        .collect();

        let server_exists = self.server_exists();

        if self.did_find_server && server_exists {
            return Ok(SERVER_PATH.to_string());
        }

        zed::set_language_server_installation_status(
            id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );

        for (dep, &version) in &node_dependencies {
            let installed_version = zed::npm_package_installed_version(dep)?;
            let latest_version = zed::npm_package_latest_version(dep)?;
            let mut version_to_install = version.to_string();

            if version == "*" {
                version_to_install = latest_version.clone();
            }

            if installed_version.as_ref().map(String::as_str) != Some(version_to_install.as_str()) {
                zed::set_language_server_installation_status(
                    // Could this be updated to update the status of which dependency is being installed
                    id,
                    &zed::LanguageServerInstallationStatus::Downloading,
                );
                zed::npm_install_package(dep, &version_to_install)?;
                println!("{} installed or updated successfully.", dep);
            }
        }

        self.did_find_server = true;
        Ok(SERVER_PATH.to_string())
    }

    pub fn label_for_completion(
        &self,
        _language_server_id: &zed::LanguageServerId,
        completion: Completion,
    ) -> Option<zed::CodeLabel> {
        println!("Label for completion {:?}", completion.kind);
        let highlight_name = match completion.kind? {
            CompletionKind::Class | CompletionKind::Interface => "type",
            CompletionKind::Constructor => "type",
            CompletionKind::Constant => "constant",
            CompletionKind::Function | CompletionKind::Method => "function",
            CompletionKind::Property | CompletionKind::Field => "property",
            CompletionKind::Variable => "variable",
            CompletionKind::Keyword => "keyword",
            CompletionKind::Value => "value",
            _ => return None,
        };

        let len = completion.label.len();
        let name_span = CodeLabelSpan::literal(completion.label, Some(highlight_name.to_string()));

        Some(zed::CodeLabel {
            code: Default::default(),
            spans: if let Some(detail) = completion.detail {
                vec![
                    name_span,
                    CodeLabelSpan::literal(" ", None),
                    CodeLabelSpan::literal(detail, None),
                ]
            } else {
                vec![name_span]
            },
            filter_range: (0..len).into(),
        })
    }
}
