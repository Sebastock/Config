;;----------------------------------------------------------;;
;;-------     Mon "précieux" .emacs.el       ---------------;;
;;-------             sebastock 16.06.2015   ---------------;;
;;----------------------------------------------------------;;
;;
;;     ___ _ __ ___   __ _  ___ ___     ___  _
;;    / _ \ '_ ` _ \ / _` |/ __/ __|   / _ \| |
;;  _ | __/ | | | | | (_| | (__\__ \ _ | __/| |
;; (_)\___|_| |_| |_|\__,_|\___|___/(_)\___/|_|
;;
;;
;; shortcut
;; [f2] : save macro (pref choice: M-1, M-2 ...)
;; [f3] : define macro (default) (begin)
;; [f4] : execute macro (default) (end macro)
;; [f5] : server-without-annoying-message
;; [f6] : active-yasnippet
;; [f7] : speedbar (with one frame)
;; [f8] : add-a-number
;; [f10] : open-in-nautilus
;; [f11] : open-in-guake

;;--------------- A) Display ---------------;;
;;------------------------------------------;;
;;---- Color theme
(if window-system
    (progn
      (require 'color-theme)
      ;;(load "/usr/share/emacs23/site-lisp/emacs-goodies-el/color-theme-library.el")
      ;;(color-theme-dark-blue2)
      ;;(color-theme-gnome2)
      (load "~/.emacs.d/zenburn_seb.el")
      ) )
(setq inhibit-startup-message t) ; no startup message
(show-paren-mode t) ; show the other parenthesis in color
(setq line-number-mode t) ; show line number
(setq column-number-mode t) ; show column number
(global-visual-line-mode 1) ; show the line like any editor
(menu-bar-mode -1) ; no menu
(setq-default fill-column 10000000)
(modify-frame-parameters nil '((wait-for-wm . nil)) ) ; no waiting
;; special psa
(set-face-attribute 'default (selected-frame) :height 135)
;;---- no menu bar (barre d'icônes)
(if window-system
    (tool-bar-mode 0)
  )
(scroll-bar-mode -1)			; no scroll-bar
;;(global-linum-mode t)
(global-set-key (kbd "M-o") 'other-window)

;;---- windows size
(menu-bar-mode nil)
;;(set-screen-width 120)
;;(set-screen-height 50)
;;---- tab
(load "~/.emacs.d/tabbar_seb.el")
;;---------- B) Scrolling ----------;;
;;------------------------------------------------;;
(setq scroll-margin 3)
(setq scroll-step 0)
(setq scroll-conservatively 100) ;100
;;---- scrolling super fast
(defun scroll-up-5 (n)
  "Scroll up by 5 lines"
  (interactive "p")
  (dotimes (i 5) (previous-line n)))
(defun scroll-down-5 (n)
  "Scroll up by 5 lines"
  (interactive "p")
  (dotimes (i 5) (next-line n)))
(global-set-key [C-up] 'scroll-up-5)
(global-set-key [C-down] 'scroll-down-5)
;;---------- C) Writing ----------;;
;;------------------------------------------------;;
;;---- Cua-mode
(cua-mode t) ; C-x C-c C-v
(setq c-basic-offset 4) ; 4 space for the indentation
(delete-selection-mode 1) ; erase selectionned text
(global-set-key "\C-m" 'newline-and-indent) ; automatic indentation
(fset 'indentAll "\C-xh\234\C-g") ; indent all the buffer
(global-set-key "\C-ci" 'indentAll)
(fset 'yes-or-no-p 'y-or-n-p) ; no more yes and no
(setq x-select-enable-primary nil); stops killing/yanking interacting with primary X11 selection
(setq x-select-enable-clipboard t); makes killing/yanking interact with clipboard X11 selection
(global-set-key (kbd "C-M-y") 'browse-kill-ring) ; browse the kill-ring
(global-set-key [f2] 'kmacro-bind-to-key) ; shortcut
;;---- cut or copy one line
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end)) (message "Copied line")
       (list (line-beginning-position) (line-end-position))) ;(line-beginning-position 2)
   ))
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-end-position))) ;(line-beginning-position 2)
   ))
;;---- sentence-highlight
;;(load "~/.emacs.d/sentence-highlight.el")
;;---------- D) Backup file~ ----------;;
;;------------------------------------------;;
(defvar user-temporary-file-directory "~/Computer/Emacs/backup/")
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
	(,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))
;; J'utilisais précédement "(defun make-backup-file-name (file)"
;; mais cette solution ne fonctionne plus...
;; Supplément pour emacs23: delete excess backup versions silently.
(setq delete-old-versions t)
;;--------- E) Useful and smart extensions ---------;;
;;--------------------------------------------------;;
;;
;; Smart-tab, Yasnippet, speedbar (one frame)
;;
;;---- Yasnippet mode
(defun active-yasnippet ()
  "Activate the yasnippet mode"
  (interactive)
  (add-to-list 'load-path "~/.emacs.d/yasnippet-0.6.1c")
  (require 'yasnippet) ;; not yasnippet-bundle
  (yas/initialize)
  (setq yas/root-directory "~/.emacs.d/mysnippets")
  (yas/load-directory yas/root-directory)
  )
(global-set-key [f6] 'active-yasnippet) ; shortcut
;;---- speedbar
(load "~/.emacs.d/sr-speedbar.el")
(require 'sr-speedbar)
(defalias 'speedbar 'sr-speedbar-toggle)
(setq sr-speedbar-width-x 40)
(setq sr-speedbar-width 40)
(global-set-key [f7] 'speedbar) ; shortcut
;;---- minimap
(load "~/.emacs.d/minimap.el")
;;---- tags
(substitute-key-definition
 'find-tag 'find-tag-other-window (current-global-map))
;;--------- F) Miscellaneous ---------;;
;;---------------------------------------------;;
;; remove the "smart" behavior of "_" in R
(ess-toggle-underscore nil)
;; start server without message
(defun server-without-annoying-message ()
  "Server start, but we can kill buffer without being annoyed"
  (interactive)
  ;; the function
  (server-start)
  (remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
  )
(global-set-key [f5] 'server-without-annoying-message)
;; add a number to another number
(defun my-increment-number-decimal (&optional arg)
  "Increment the number forward from point by 'arg'."
  (interactive "p*")
  (save-excursion
    (save-match-data
      (let (inc-by field-width answer)
	(setq inc-by (if arg arg 1))
	(skip-chars-backward "0123456789")
	(when (re-search-forward "[0-9]+" nil t)
	  (setq field-width (- (match-end 0) (match-beginning 0)))
	  (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
	  (when (< answer 0)
	    (setq answer (+ (expt 10 field-width) answer)))
	  (replace-match (format (concat "%0" (int-to-string field-width) "d")
				 answer)))))))
(defun add-a-number (increment)
  (interactive "nIncrement: ")
  (my-increment-number-decimal increment))
(global-set-key [f8] 'add-a-number) ; shortcut
;;------------------- M) Special mode -------------------;;
;;------------------------------------------------------------;;
;;
;; Auctex, Text, Org-mode
;;
;;------------ M.1) Auctex ------------;;
;;-------------------------------------;;
;; indenter à la nouvelle ligne
(setq TeX-newline-function 'newline-and-indent)
;; Config de Reftex pour LaTeX
(autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
(autoload 'reftex-citation "reftex-cite" "Make-citation" nil)
(autoload 'reftex-index-phrase-mode "reftex-index" "Phrase mode" t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) ; Pour AUCTeX LaTeX mode
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
(setq reftex-label-alist '((nil ?e nil "~\\eqref{%s}" nil nil)))
(setq reftex-ref-macro-prompt nil)
;; Configuration des visualiseurs
(require 'tex)
(TeX-global-PDF-mode t)
(setq TeX-view-program-selection
      '((output-dvi "DVI Viewer")
	(output-pdf "PDF Viewer")))
(setq TeX-view-program-list
      '(("DVI Viewer" "okular %o")
	("PDF Viewer" "okular --unique %o#src:%n%b")))
;; ("PDF Viewer" "okular %o")))
;; ("PDF Viewer" "evince %o")))
;; C-cc
(defun tex-build-command-function (cmd &optional recenter-output-buffer
				       save-buffer override-confirm)
  "Build a TeX-command function."
  (` (lambda()
       (interactive)
       (when (, save-buffer) (save-buffer))
       (when (, recenter-output-buffer) (TeX-recenter-output-buffer nil))
       (TeX-command (, cmd) 'TeX-master-file (if (, override-confirm) 1 -1)))))
(global-set-key "\C-cc" (tex-build-command-function "LaTeX" nil t))
;;------------ M.2) Text ------------;;
;;-----------------------------------;;
(require 'generic-x) ;; we need this
(define-generic-mode
    'sebText-mode ;; name of the mode to create
  '("##") ;; comments start with '!!'
  '("account" "user" "password") ;; some keywords
  '(("=" . 'font-lock-operator) ;; '=' is an operator
    (";" . 'font-lock-builtin)) ;; ';' is a a built-in
  '("\\.txt$") ;; files for which to activate this mode
  nil ;; other functions to call
  "A mode for text files" ;; doc string for this mode
  )
;; see http://emacs-fu.blogspot.com/2010/04/creating-custom-modes-easy-way-with.html
;;--------- M.3) Org-mode ---------;;
;;---------------------------------;;
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;;--------- M.4) Octave ---------;;
;;-------------------------------;;
;; special imenu for octave
(setq imenu-generic-expression
      '((nil "\s-?\\([A-Z]\.[1-9]\).*\\)\s-*" 1)))
(add-hook 'octave-mode-hook
	  '(lambda()
	     (setq imenu-generic-expression
		   '((nil "\s-?\\([A-Z]\.[1-9]\).*\\)\s-*" 1)))
	     (local-set-key (kbd "C-c =") 'imenu)
	     ))
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (append '(("\\.m$" . octave-mode)) auto-mode-alist))
;;--------- M.5) Markdown ---------;;
;;---------------------------------;;
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;;------------------- GUI -------------------;;
;;------------------------------------------------;;
;;--------- G.1) Guake ---------;;
;;------------------------------;;
;; 1) guake -n --execute-command="cd 'pwd'" (shell-command-to-string "pwd")
;; 2) (defun shell-command-on-buffer ()
;; "Asks for a command and executes it in inferior shell with current buffer as input."
;; (interactive)
;; (shell-command-on-region
;; (point-min) (point-max)
;; (read-shell-command "Shell command on buffer: ")))
;; 3) (global-set-key (kbd "M-\"") 'shell-command-on-buffer)
(defun open-guake-on-buffer ()
  "open a guake tab right here!"
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   "guake --new-tab=new --execute-command=\"cd `pwd`\""))
(global-set-key [f11] 'open-guake-on-buffer)
;;--------- G.2) Nautilus ---------;;
;;---------------------------------;;
(defun open-nautilus-on-buffer ()
  "open nautilus right here!"
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   "nautilus --new-window ."))
(global-set-key [f10] 'open-nautilus-on-buffer)
;;------------------- Fancy -------------------;;
;;--------------------------------------------------;;
;; multiple cursor
(add-to-list 'load-path "~/.emacs.d/multiple-cursors.el-master")
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-source-correlate-method (quote synctex))
 '(TeX-source-correlate-mode t)
 '(TeX-source-correlate-start-server t)
 '(tabbar-separator (quote (0.5))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
