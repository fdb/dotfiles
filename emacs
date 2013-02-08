(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

; Enable eldoc in Clojure buffers
(add-hook 'nrepl-interaction-mode-hook
	  'nrepl-turn-on-eldoc-mode)
; Stop the error buffer from popping up while working in the REPL
(setq nrepl-popup-stacktraces nil)
; Enable CamelCase support for forward-word, backward-word
(add-hook 'nrepl-mode-hook 'subword-mode)
; Enable paredit
(add-hook 'nrepl-mode-hook 'paredit-mode)

