pub mod language_servers;

use std::env;
use zed_extension_api::{self as zed, Result};

// Import ember and glint server implementations.
use crate::language_servers::ember::EmberServer;
use crate::language_servers::glint::GlintServer;

struct UnifiedExtension {
    ember: EmberServer,
    glint: GlintServer,
}

impl UnifiedExtension {
    fn new_extension() -> Self {
        Self {
            ember: EmberServer { did_find_server: false },
            glint: GlintServer { did_find_server: false },
        }
    }
}

impl zed::Extension for UnifiedExtension {
    fn new() -> Self {
        Self::new_extension()
    }

    fn language_server_command(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        _worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let server_path = if language_server_id.as_ref() == "glint" {
            self.glint.server_script_path(language_server_id)?
        } else {
            self.ember.server_script_path(language_server_id)?
        };
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

    fn language_server_initialization_options(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> zed_extension_api::Result<Option<zed::serde_json::Value>> {
        let settings = zed::settings::LspSettings::for_worktree(language_server_id.as_ref(), worktree)
            .ok()
            .and_then(|s| s.initialization_options.clone())
            .unwrap_or_default();
        Ok(Some(settings))
    }

    fn language_server_workspace_configuration(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> zed_extension_api::Result<Option<zed::serde_json::Value>> {
        let settings = zed::settings::LspSettings::for_worktree(language_server_id.as_ref(), worktree)
            .ok()
            .and_then(|s| s.settings.clone())
            .unwrap_or_default();
        Ok(Some(settings))
    }

    fn label_for_completion(
        &self,
        language_server_id: &zed::LanguageServerId,
        completion: zed::lsp::Completion,
    ) -> Option<zed::CodeLabel> {
        if language_server_id.as_ref() == "glint" {
            self.glint.label_for_completion(language_server_id, completion)
        } else {
            self.ember.label_for_completion(language_server_id, completion)
        }
    }
}

zed::register_extension!(UnifiedExtension);
