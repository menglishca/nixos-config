{ config, pkgs, ... }:

{
    sops.secrets.openrouter-api-key = {};
    sops.secrets.openai-api-key = {};

    services.librechat = {
        enable = true;
        enableLocalDB = true;
        openFirewall = true;

        env = {
            HOST = "127.0.0.1";
            PORT = 3080;

            APP_TITLE = "Matt's AI";

            ALLOW_REGISTRATION = false;
            ALLOW_EMAIL_LOGIN = false;

            # Anything that isn't secret can go here.
            SEARCH = true;
        };

        # This file contains the secret environment variables.
        credentialsFile = config.sops.secrets.openrouter-api-key.path;

        settings = {
            cache = true;
            interface = {
                fileSearch = true;
                modelSelect = true;
                parameters = true;
                presets = true;
                prompts = {
                    use = true;
                    create = true;
                    share = false;
                    public = false;
                };
                bookmarks = true;
                multiConvo = true;
                fileCitations = true;
            };
            endpoints = {
                custom = {
                    name = "OpenRouter";
                    apiKey = "${config.sops.secrets.openrouter-api-key.path}";
                    baseURL = "https://openrouter.ai/api/v1";
                    headers = {
                        "x-librechat-body-parentmessageid" = "{{LIBRECHAT_BODY_PARENTMESSAGEID}}";
                    };
                    models = {
                        default = [ "xiaomi/mimo-v2.5" ];
                        fetch = true;
                    };
                    titleConvo = true;
                    titleModel = "deepseek/deepseek-v4-flash";
                    dropParams = [ "stop" ];
                    addParams = {
                        web_search = true;
                    };
                    modelDisplayLabel = "OpenRouter";
                };
            };
        };
    };
}