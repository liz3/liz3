(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))


(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)
(setq-default tab-width 2
              indent-tabs-mode nil
              column-number-mode t
              require-final-newline t
              make-backup-files nil)
(global-auto-revert-mode t)

(setq erc-rename-buffers t)

;;(toggle-scroll-bar -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(electric-indent-mode -1)
(global-linum-mode t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(show-paren-mode t)

(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))
(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))
(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c l") 'magit-log-buffer-file)
(global-set-key (kbd "C-x /") 'comment-dwim)

(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
    (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://strapdownjs.com/v/0.2/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
	 (current-buffer)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js-indent-level 2)
 '(package-selected-packages
   '(elixir-mode tide nord-theme ag go-mode rjsx-mode web-mode yasnippet-snippets js2-mode use-package powerline magit)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erc-input-face ((t (:foreground "brightcyan"))))
 '(erc-my-nick-face ((t (:foreground "brightcyan" :weight bold)))))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1)
  :config
  (add-to-list 'yas-snippet-dirs (locate-user-emacs-file "snippets")))

(add-hook 'typescript-mode-hook #'setup-tide-mode)
(load-theme 'nord t)
(require 'powerline)
(powerline-default-theme)
(require 'rust-mode)
(require 'js2-mode)
(require 'rjsx-mode)
(require 'go-mode)
(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))

(add-hook 'web-mode-hook
         (lambda ()
           (when (string-equal "tsx" (file-name-extension buffer-file-name))
             (setup-tide-mode))))
