{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      alias = {
        set-upstream = "!git branch --set-upstream-to=origin/$(git symbolic-ref --short HEAD)";
        "undo-commit" = "reset --soft HEAD~1";
        "current-branch" = "symbolic-ref --short HEAD";
        tmp-revert = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            if [[ $(git log --pretty=format:%s -1) == \"tmp\" ]] ; then \
              git reset --soft HEAD~1 && git restore --staged . ; \
            fi; \
          };f
        '' ;
        "tmp-commit" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git tmp-revert; \
            git add -A; \
            git commit --no-verify -m \"tmp\"; \
          };f
        '';
        "pull-this" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git pull origin $(git current-branch); \
          };f
        '';
        "push-this" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git push origin $(git current-branch); \
          };f
        '';
        "push-force" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git push --force-with-lease origin $(git current-branch); \
          };f
        '';
        "checkout-previous" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git checkout $(git previous-branch); \
          };f
        '';
        "pull-previous" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git pull origin $(git previous-branch); \
          };f
        '';
        "grep-branch" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git branch -a | sed -e 's/[ \\*]*//' | grep -e $1; \
          };f "
        '';
        "grep-branch-remote" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git branch -a | sed -e 's/[ \\*]*//' | grep -e '^remotes' | grep -e $1; \
          };f
        '';
        "grep-branch-local" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git branch -a | sed -e 's/[ \\*]*//' | grep -v -e '^remotes' | grep -e $1; \
          };f
        '';
        "last-branches" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git reflog show --pretty=format:'%gs ~ %gd' --date=relative \
            | grep 'checkout:' \
            | grep -oE '[^ ]+ ~ .*' \
            | awk -F \"~\" '!seen[$1]++' \
            | awk 'BEGIN { FS=\"~\" } { print $1 }' \
            | head -n $1; \
          };f
        '';
        "nth-last-branch" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f () { \
            git last-branches $(($1 + 1)) | sed -n \"$(($1 + 1)) p\"; \
          };f
        '';
        "previous-branch" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f () { \
            git nth-last-branch 1; \
          };f
        '';
        "checkout-last-branch" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            git checkout $(git nth-last-branch $1); \
          };f
        '';
        "last-commit-now" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            LC_ALL=C GIT_COMMITTER_DATE=\"$(date)\" git commit --amend --no-edit --date \"$(date)\" --no-verify; \
          };f
        '';
        "ammend-same-date" = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f() { \
            LC_ALL=C GIT_COMMITTER_DATE=\"$(git log -n 1 --format=%aD)\"  git commit --amend --no-edit --date=\"$(git log -n 1 --format=%aD)\" ; \
          };f
        '';
        oops = builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''
          !f(){ \
            if [ \"$1\" == builtins.replaceStrings [ "\n" "\\" ] [ " " "" ] ''' ]; then \
              git commit --amend --no-edit; \
            else \
              git commit --amend \"$@\"; \
            fi;\
          };f
        '';
      };
    };
  };
}