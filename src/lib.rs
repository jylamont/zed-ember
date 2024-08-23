use std::collections::HashMap;
// use std::path::PathBuf;
use std::{env, fs};
use zed::settings::LspSettings;
use zed_extension_api::{self as zed, serde_json, Result};

struct EmberExtension {
    did_find_server: bool,
}

const SERVER_PATH: &str =
    "node_modules/@ember-tooling/ember-language-server/bin/ember-language-server.js";

impl EmberExtension {
    fn server_exists(&self) -> bool {
        fs::metadata(SERVER_PATH).map_or(false, |stat| stat.is_file())
    }

    fn server_script_path(&mut self, id: &zed::LanguageServerId) -> Result<String> {
        let node_dependencies: HashMap<&str, &str> = [
            ("@ember-tooling/ember-language-server", "2.30.3"),
            ("els-addon-file-watcher", "0.0.2"),
            ("els-addon-glint", "0.6.4"),
            ("els-a11y-addon", "1.0.4"),
            ("ember-fast-cli", "1.3.1"),
            ("els-intl-addon", "1.0.3"),
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
}

impl zed::Extension for EmberExtension {
    fn new() -> Self {
        println!("NEW!");
        Self {
            did_find_server: false,
        }
    }

    fn language_server_command(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        _worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let server_path = self.server_script_path(language_server_id)?;
        Ok(zed::Command {
            command: zed::node_binary_path()?,
            args: vec![
                env::current_dir()
                    .unwrap()
                    .join(&server_path)
                    .to_string_lossy()
                    .to_string(),
                "--stdio".to_string(),
            ],
            env: Default::default(),
        })
    }

    fn language_server_workspace_configuration(
        &mut self,
        _language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<serde_json::Value>> {
        let settings = LspSettings::for_worktree("ember-language-server", worktree)
            .ok()
            .and_then(|lsp_settings| lsp_settings.settings.clone())
            .unwrap_or_default();

        Ok(Some(serde_json::json!({
            "els": settings
        })))
    }

    // fn language_server_initialization_options(
    //     &mut self,
    //     _language_server_id: &zed::LanguageServerId,
    //     _worktree: &zed::Worktree,
    // ) -> Result<Option<serde_json::Value>> {
    //     Ok(Some(serde_json::json!({
    //         "els.codeLens.relatedFiles": true,
    //         "els.local.useBuiltinLinting": true,
    //         "els.local.addons": ["/Users/Lou/Library/Application Support/Zed/extensions/work/ember/node_modules/els-addon-file-watcher", "/Users/Lou/Library/Application Support/Zed/extensions/work/ember/node_modules/els-addon-glint", "/Users/Lou/Library/Application Support/Zed/extensions/work/ember/node_modules/els-a11y-addon", "/Users/Lou/Library/Application Support/Zed/extensions/work/ember/node_modules/ember-fast-cli", "/Users/Lou/Library/Application Support/Zed/extensions/work/ember/node_modules/els-intl-addon"]
    //     })))
    // }

    // - `els.server.debug.port` - LS debug port
    // - `els.server.debug.enabled` - disable / enable LS debug
    // - `els.codeLens.relatedFiles` - disable / enable related files
    // - `els.local.useBuiltinLinting` - disable / enable ember-template-lint integration
    // - `els.local.useBuiltinFoldingRangeProvider` - disable / enable folding range provider (hbs)
    // - `els.local.addons`

    // fn language_server_initialization_options(
    //     &mut self,
    //     _: &zed::LanguageServerId,
    //     _: &zed::Worktree,
    // ) -> Result<Option<serde_json::Value>> {
    //     // let current_dir = env::current_dir().unwrap_or(PathBuf::new());
    //     // let node_modules_path = current_dir.join("node_modules");
    //     // let ts_lib_path = node_modules_path
    //     //     .join("typescript/lib")
    //     //     .to_string_lossy()
    //     //     .to_string();
    //     // let ng_service_path = node_modules_path
    //     //     .join("@ember-tooling/ember-language-server/bin")
    //     //     .to_string_lossy()
    //     //     .to_string();
    //     Ok(Some(serde_json::json!({
    //         // "typescript": {
    //         //     "tsdk": ts_lib_path,
    //         // },
    //         // "tsProbeLocations": ts_lib_path,
    //         // "ngProbeLocations": ng_service_path,
    //     })))
    // }

    // fn label_for_completion(
    //     &self,
    //     _language_server_id: &zed::LanguageServerId,
    //     completion: Completion,
    // ) -> Option<zed::CodeLabel> {
    //     println!("Label for completion {:?}", completion.kind);
    //     let highlight_name = match completion.kind? {
    //         CompletionKind::Class | CompletionKind::Interface => "type",
    //         CompletionKind::Constructor => "type",
    //         CompletionKind::Constant => "constant",
    //         CompletionKind::Function | CompletionKind::Method => "function",
    //         CompletionKind::Property | CompletionKind::Field => "property",
    //         CompletionKind::Variable => "variable",
    //         CompletionKind::Keyword => "keyword",
    //         CompletionKind::Value => "value",
    //         _ => return None,
    //     };

    //     let len = completion.label.len();
    //     let name_span = CodeLabelSpan::literal(completion.label, Some(highlight_name.to_string()));

    //     Some(zed::CodeLabel {
    //         code: Default::default(),
    //         spans: if let Some(detail) = completion.detail {
    //             vec![
    //                 name_span,
    //                 CodeLabelSpan::literal(" ", None),
    //                 CodeLabelSpan::literal(detail, None),
    //             ]
    //         } else {
    //             vec![name_span]
    //         },
    //         filter_range: (0..len).into(),
    //     })
    // }
}

zed::register_extension!(EmberExtension);
