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
 '(clojure-mode clojure-test-mode paredit))

; Inferior lisp uses Leiningen
(setq inferior-lisp-program "lein repl")

; Enable eldoc in Clojure buffers
(add-hook 'nrepl-interaction-mode-hook
    'nrepl-turn-on-eldoc-mode)
; Stop the error buffer from popping up while working in the REPL
(setq nrepl-popup-stacktraces nil)
; Enable CamelCase support for forward-word, backward-word
(add-hook 'nrepl-mode-hook 'subword-mode)
; Enable paredit in clojure mode
(add-hook 'clojure-mode-hook 'paredit-mode)
; Enable whitespace in clojure mode
(add-hook 'clojure-mode-hook 'whitespace-mode)
; Enable paredit in nrepl
(add-hook 'nrepl-mode-hook 'paredit-mode)
