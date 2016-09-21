; Determine the underlying operating system
(setq platform-mac (eq system-type 'darwin))
(setq platform-linux (eq system-type 'gnu/linux))
(setq platform-windows (eq system-type 'windows-nt))

;===============================================================================
; Package settings

; (require 'package)
; (add-to-list 'package-archives
;              '("marmalade" . "http://marmalade-repo.org/packages/"))
; (package-initialize)

; (when (not package-archive-contents)
;   (package-refresh-contents))
;
; (defun ensure-packages-installed (packages)
;   (dolist (p packages)
;     (when (not (package-installed-p p))
;       (package-install p))))
;
; (ensure-packages-installed
; '(clojure-mode clojure-test-mode nrepl rust-mode))

;===============================================================================
; Editing functions

(defun fdb-save-buffer ()
  "Save the buffer after untabifying it."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (untabify (point-min) (point-max))))
  (save-buffer))

;===============================================================================
; Global settings

; Keep big history of undo information
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

; Always use spaces instead of tabs.
(setq-default indent-tabs-mode nil)

; Use shift-arrowkeys to move between windows.
(global-set-key (kbd "S-<up>") 'windmove-up)
(global-set-key (kbd "S-<down>") 'windmove-down)
(global-set-key (kbd "S-<right>") 'windmove-right)
(global-set-key (kbd "S-<left>") 'windmove-left)

; Highlight the current line.
(global-hl-line-mode 1)
(set-face-background 'hl-line "#3e3e3e")

; Home / End move to beginning / end of line.
(global-set-key (kbd "<home>") 'move-beginning-of-line)
(global-set-key (kbd "<end>") 'move-end-of-line)

; Use standard copy-paste.
(cua-mode 1)

; Highlight matching parenthesis.
(show-paren-mode 1)

; Turn off UI junk
(tool-bar-mode 0)
(scroll-bar-mode -1)

; Turn off the sound
(defun nil-bell ())
(setq ring-bell-function 'nil-bell)

; ???
;(load-library "view")
(require 'cc-mode)
(require 'compile)

; File find auto-completion
(require 'ido)
(ido-mode t)

; Windowing
(defun never-split-a-window nil)
(setq split-window-preferred-function 'never-split-a-window)
(split-window-horizontally)

; Find files
(global-set-key (kbd "M-f") 'find-file)
(global-set-key (kbd "M-F") 'find-file-other-window)
(global-set-key (kbd "M-s") 'save-buffer)

; Switching buffers
(global-set-key (kbd "M-b") 'ido-switch-buffer)
(global-set-key (kbd "M-B") 'ido-switch-buffer-other-window)

; In-file navigation
(defun previous-blank-line ()
  "Moves to the previous line containing nothing but whitespace."
  (interactive)
  (search-backward-regexp "^[ \t]*\n"))

(defun next-blank-line ()
  "Moves to the next line containing nothing but whitespace."
  (interactive)
  (forward-line)
  (search-forward-regexp "^[ \t]*\n")
  (forward-line -1))

(global-set-key (kbd "C-<up>") 'previous-blank-line)
(global-set-key (kbd "C-<down>") 'next-blank-line)

; Fonts and colors
(add-to-list 'default-frame-alist '(font . "Roboto Mono-10"))
(set-face-attribute 'default t :font "Roboto Mono-10")
(set-face-attribute 'font-lock-builtin-face nil :foreground "#f9f9f5")
(set-face-attribute 'font-lock-comment-face nil :foreground "#88846f")
(set-face-attribute 'font-lock-constant-face nil :foreground "#ff4484") ; TODO
(set-face-attribute 'font-lock-doc-face nil :foreground "gray50")  ; TODO
(set-face-attribute 'font-lock-function-name-face nil :foreground "#6edff2")
(set-face-attribute 'font-lock-keyword-face nil :foreground "#6edff2")  ; TODO
(set-face-attribute 'font-lock-string-face nil :foreground "#ebe18b")
(set-face-attribute 'font-lock-type-face nil :foreground "burlywood3")  ; TODO
(set-face-attribute 'font-lock-variable-name-face nil :foreground "burlywood3") ; TODO

(defun post-load-stuff ()
  (interactive)
  (menu-bar-mode -1)
  (set-foreground-color "#a6bacc")
  (set-background-color "#171d20")
  (set-cursor-color "#FFFFFF")
)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-hook 'window-setup-hook 'post-load-stuff t)

;===============================================================================
; C / C++

(defun fdb-find-counterpart ()
  "Find the file that corresponds to this one."
  (interactive)
  (setq fname nil)
  (setq base-filename (file-name-sans-extension buffer-file-name)))

(defun fdb-c-hook ()
  ; Tab completion
  (local-set-key (kbd "<tab>") 'dabbrev-expand)
  (local-set-key (kbd "S-<tab>") 'indent-for-tab-command)
  (local-set-key (kbd "S-<backtab>") 'indent-for-tab-command)
  (local-set-key (kbd "C-<tab>") 'indent-region)
  (abbrev-mode 1)
  (setq dabbrev-case-replace t)
  (setq dabbrev-case-fold-search t)
  (set dabbrev-upcase-means-case-search t)
)

(add-hook 'c-mode-common-hook 'fdb-c-hook)

;===============================================================================
; Clojure settings

; Inferior lisp uses Leiningen
(setq inferior-lisp-program "lein repl")
; Enable eldoc in Clojure buffers
(add-hook 'nrepl-interaction-mode-hook
    'nrepl-turn-on-eldoc-mode)
; Stop the error buffer from popping up while working in the REPL
(setq nrepl-popup-stacktraces nil)
; Enable CamelCase support for forward-word, backward-word
(add-hook 'nrepl-mode-hook 'subword-mode)
; Enable whitespace in clojure mode
(add-hook 'clojure-mode-hook 'whitespace-mode)

; Use nice key bindings to evalute expressions.
(global-set-key (kbd "C-M-<return>") 'nrepl-eval-expression-at-point)
(global-set-key (kbd "C-S-<return>") 'nrepl-load-current-buffer)
(global-set-key (kbd "C-.") 'clojure-test-run-tests)

;===============================================================================
; Compilation

(setq compilation-directory-locked nil)

(when platform-windows
  (setq platform-makescript "build.bat")
)

(when platform-mac
  (setq platform-makescript "build_osx.sh")
)

(when platform-linux
  (setq platform-makescript "./build_linux.sh")
)

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p platform-makescript) t
    (cd "../")
    (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (switch-to-buffer-other-window "*compilation*")
  (if compilation-directory-locked (cd last-compilation-directory)
  (cd find-project-from-directory)
  (find-project-directory-recursive)
  (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile platform-makescript))
  (other-window 1))
(define-key global-map "\em" 'make-without-asking)

