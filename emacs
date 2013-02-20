;===============================================================================
; Package settings

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defun ensure-packages-installed (packages)
  (dolist (p packages)
    (when (not (package-installed-p p))
      (package-install p))))

(ensure-packages-installed
 '(clojure-mode clojure-test-mode))

;===============================================================================
; Global settings

; Use shift-arrowkeys to move between windows.
(global-set-key (kbd "S-<up>") 'windmove-up)
(global-set-key (kbd "S-<down>") 'windmove-down)
(global-set-key (kbd "S-<right>") 'windmove-right)
(global-set-key (kbd "S-<left>") 'windmove-left)

; Highlight the current line.
(global-hl-line-mode 1)
(set-face-background 'hl-line "#eee")

; Use standard copy-paste.
(cua-mode 1)

; Highlight matching parenthesis.
(show-paren-mode 1)

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
