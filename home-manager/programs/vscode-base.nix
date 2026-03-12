{ config, lib, pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscode;

        profiles.default.userSettings = {
            # Editor appearance & behavior

            "editor.fontSize" = lib.mkForce 12;
            "terminal.integrated.fontSize" = lib.mkForce 12;
            "debug.console.fontSize" = lib.mkForce 12;
            "chat.editor.fontSize" = lib.mkForce 12;
            "editor.tabSize" = 4;
            "editor.rulers" = [ 120 ];
            "editor.scrollBeyondLastLine" = false;
            "editor.suggestSelection" = "first";
            "editor.detectIndentation" = true;
            "editor.multiCursorModifier" = "ctrlCmd";

            # Files & explorer
            "files.trimTrailingWhitespace" = true;
            "files.autoSave" = "onFocusChange";
            "explorer.confirmDelete" = false;
            "explorer.confirmDragAndDrop" = false;

            # Diff & Git
            "diffEditor.ignoreTrimWhitespace" = false;
            "git.mergeEditor" = false;

            # JavaScript / Jest
            "javascript.updateImportsOnFileMove.enabled" = "always";
            "jest.jestCommandLine" = "node_modules/.bin/jest";
            "jest.shell" = "/bin/bash";
        };
    };
}
