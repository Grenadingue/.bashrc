;; .myemacs

;; configure colors for a terminal with dark background
(setq frame-background-mode 'dark)

(add-to-list 'load-path "~/.emacs.d/s")
(add-to-list 'load-path "~/.emacs.d/ocaml")
(add-to-list 'load-path "~/.emacs.d/sym-lock")
(add-to-list 'load-path "~/.emacs.d/whitespace")
(add-to-list 'load-path "~/.emacs.d/qml")
(add-to-list 'load-path "~/.emacs.d/php")
(add-to-list 'load-path "~/.emacs.d/debug")
(add-to-list 'load-path "~/.emacs.d/arduino-mode")
(add-to-list 'load-path "~/.emacs.d/dockerfile-mode")
;; (load-file "~/.emacs.d/arduino-mode/arduino-mode.el")

(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

(add-to-list 'auto-mode-alist '("\\.phtml" . html-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . html-mode))
;; (add-to-list 'auto-mode-alist '("\\.php[34]?\\'" . html-mode))
;; (add-to-list 'auto-mode-alist '("\\.[sj]?html?\\'" . html-mode))
;; (add-to-list 'auto-mode-alist '("\\.jsp\\'" . html-mode))
;; (add-to-list 'auto-mode-alist '("\\.inc\\'" . html-mode))

;; Blank end-of-line auto removal with ("~/.emacs.d/whitespace")
(setq show-trailing-whitespace t)
(setq-default show-trailing-whitespace t)

;; Select + up
(define-key input-decode-map "\e[1;2A" [S-up])

;; Enable QML
(require 'qml-mode)

;; Enable Docker
;; https://domeide.github.io/
;; https://github.com/spotify/dockerfile-mode
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile" . dockerfile-mode))
