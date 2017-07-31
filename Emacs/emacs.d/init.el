;;----------------------------------------------------------;;
;;-------     Mon "précieux" .emacs.el       ---------------;;
;;-------             sebastock  30.01.2016   --------------;;
;;----------------------------------------------------------;;
;;
;;     ___ _ __ ___   __ _  ___ ___     ___  _
;;    / _ \ '_ ` _ \ / _` |/ __/ __|   / _ \| |
;;  _ | __/ | | | | | (_| | (__\__ \ _ | __/| |
;; (_)\___|_| |_| |_|\__,_|\___|___/(_)\___/|_|
;;
;;
;; shortcut
;; [f3/f4] : define macro
;; [f5]    : server-without-annoying-message
;; [f6]    : active-yasnippet
;; [f7]    : sr-speedbar
;; [f8]    : add-a-number
;; [f10]   : open-in-nautilus
;; [f11]   : open-in-guake

;;-- package systems
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;;--------------------------------------------------------;;
;;                   A) Visual theme                      ;;
;;--------------------------------------------------------;;
;; load dark theme
(if window-system
    (progn
      (require 'color-theme)
      (load "~/.emacs.d/zenburn_seb.el")
      ))
(set-face-attribute 'default (selected-frame) :height 135)
;; zen interface
(scroll-bar-mode -1)			; no scroll-bar
(tool-bar-mode 0)			; no tool-bar
(menu-bar-mode -1)			; no menu-bar

;;--------------------------------------------------------;;
;;           B) Emacs as a 'normal' editor                ;;
;;--------------------------------------------------------;;
;;(setq cua-remap-control-v nil)
(cua-mode t)			               ; C-x, C-c, C-v
(global-visual-line-mode 1)            ; show the line like any editor
(setq inhibit-startup-message t)       ; no startup message
(delete-selection-mode 1)              ; erase selectionned text
(setq c-basic-offset 4)                ; 4 space for the indentation
(setq scroll-conservatively 100)       ; scroll as usual
(setq scroll-margin 3)		           ; keep 2 lines above & below cursor
(fset 'yes-or-no-p 'y-or-n-p)          ; no more yes and no just y/n
(setq-default fill-column 10000000)    ; don't cut the line
;; (setq x-select-enable-primary nil)
;; (setq x-select-enable-clipboard t)
(setq confirm-kill-emacs #'y-or-n-p)

;;--------------------------------------------------------;;
;;           C) Emacs as a 'modern' editor                ;;
;;--------------------------------------------------------;;
(show-paren-mode t)                    ; show the other parenthesis in color
(load "~/.emacs.d/tabbar_seb.el")      ; tab (C-up,C-down to switch)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))	    ; switch between frame with shift-... (instead of C-x o)
(global-set-key "\C-o" 'other-window)
(global-set-key "\C-m" 'newline-and-indent) ; automatic indentation
;; speedbar
;; (load "~/.emacs.d/sr-speedbar.el")     ; speedbar in one frame
;; (setq speedbar-use-images nil)	       ; turn off the ugly icons
;; (setq sr-speedbar-right-side nil)      ; left-side pane
;; (setq sr-speedbar-auto-refresh t)      ; don't refresh on buffer changes
;; (speedbar-add-supported-extension ".r")
;; (speedbar-add-supported-extension ".csv")
;; (setq speedbar-show-unknown-files t)
(global-set-key [f7] 'sr-speedbar-toggle)

;;--------------------------------------------------------;;
;;         D) Emacs as a 'customized' editor              ;;
;;--------------------------------------------------------;;
;; D.1) indent all the buffer (C-c i)
;;-----------------------------------
(fset 'indentAll "\C-xh\234\C-g")
(global-set-key "\C-ci" 'indentAll)
;; D.2) scrolling super fast (C-up, C-down)
;;-----------------------------------------
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
;; scroll by half-page, with same line position pointer
;;   see also https://www.emacswiki.org/emacs/Scrolling
(defun zz-scroll-half-page (direction)
  "Scrolls half page up if `direction' is non-nil, otherwise will scroll half page down."
  (let ((opos (cdr (nth 6 (posn-at-point)))))
    ;; opos = original position line relative to window
    (move-to-window-line nil)  ;; Move cursor to middle line
    (if direction
	(recenter-top-bottom -1)  ;; Current line becomes last
      (recenter-top-bottom 0))  ;; Current line becomes first
    (move-to-window-line opos)))  ;; Restore cursor/point position
(defun zz-scroll-half-page-down ()
  "Scrolls exactly half page down keeping cursor/point position."
  (interactive)
  (zz-scroll-half-page nil))
(defun zz-scroll-half-page-up ()
  "Scrolls exactly half page up keeping cursor/point position."
  (interactive)
  (zz-scroll-half-page t))
(global-set-key [next] 'zz-scroll-half-page-down)
(global-set-key [prev] 'zz-scroll-half-page-up)
;; D.3) cut or copy one line
;; -------------------------
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end)) (message "Copied line")
       (list (line-beginning-position) (line-end-position)))
   ))
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-end-position)))
   ))
;; D.4) power-line
;;----------------
(require 'powerline)
(powerline-center-theme)
;; D.5) shortcuts
;;---------------
(global-set-key "\C-t" 'set-mark-command)
(global-set-key "\C-n" 'forward-list)
(global-set-key "\C-p" 'backward-list)

;;--------------------------------------------------------;;
;;            E) Emacs as a 'superb' editor               ;;
;;--------------------------------------------------------;;
;; E.1) browse the kill-ring (C-M-y)
;;----------------------------------
(global-set-key (kbd "C-M-y") 'browse-kill-ring)
;; E.2) backup files
;;------------------
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
(setq delete-old-versions t)
;; E.3) yasnippet (F6))
;;---------------------
(defun active-yasnippet ()
  "Activate the yasnippet mode"
  (interactive)
  (yas-global-mode 1)
  (setq yas/root-directory "~/.emacs.d/mysnippets")
  (yas/load-directory yas/root-directory)
  )
(global-set-key [f6] 'active-yasnippet)
;; E.4) tags (fortran, c/c++) using M-.
;;-------------------------------------
(substitute-key-definition
 'find-tag 'find-tag-other-window (current-global-map))
;; E.5) emacs server (F5)
;;-----------------------
(defun server-without-annoying-message ()
  "Server start, but we can kill buffer without being annoyed"
  (interactive)
  (server-start)
  (remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
  )
(global-set-key [f5] 'server-without-annoying-message)
;; E.6) add a number to another number (F8)
;;-----------------------------------------
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
(global-set-key [f8] 'add-a-number)
;; E.7) open Nautilus or Guake at the location of the buffer (f10/f11)
;;--------------------------------------------------------------------
(defun open-nautilus-on-buffer ()
  "open nautilus right here!"
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   "nautilus --new-window ."))
(global-set-key [f10] 'open-nautilus-on-buffer)
(defun open-guake-on-buffer ()
  "open a guake tab right here!"
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   "guake --new-tab=new --execute-command=\"cd `pwd`\""))
(global-set-key [f11] 'open-guake-on-buffer)
;; E.8) multiple cursor
;;---------------------
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;; E.9) Ido (smart guy)
;;---------------------
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(ido-vertical-mode 1)
(setq ido-auto-merge-work-directories-length -1)
;; E.10) Avy-mode (fast moving around)
(setq avy-keys
      (nconc (number-sequence ?a ?z)
             (number-sequence ?A ?Z)
             (number-sequence ?1 ?9)
             '(?0)))
(global-set-key (kbd "<C-f10>") 'avy-goto-word-or-subword-1)

;;--------------------------------------------------------;;
;;           F) special mode                              ;;
;;--------------------------------------------------------;;
;; F.1) Auctex
;;(require 'tex)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq TeX-newline-function 'newline-and-indent)
;;(TeX-global-PDF-mode t)
;; Informative error message
(setq LaTeX-command-style
      '(("" "%(PDF)%(latex) -file-line-error %S%(PDFout)")))
;; To have nice eqref and no prompt
(setq reftex-ref-macro-prompt nil)
(setq reftex-label-alist '(AMSTeX))
;; config to have the LaTeX file link with the PDF
;;    add "\usepackage[active]{srcltx}" in the LaTeX file
(setq TeX-source-correlate-method (quote synctex))
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-start-server t)
;; need Okular
(setq TeX-view-program-selection
      '((output-dvi "DVI Viewer")
	(output-pdf "PDF Viewer")))
(setq TeX-view-program-list
      '(("DVI Viewer" "okular %o")
	("PDF Viewer" "okular --unique %o#src:%n%b")))
;; config pour okular:
;;    settings > configure Okular > Editor
;;    Emacs client, command: "emacsclient -a emacs --no-wait +%l %f"
;; Short-cut to compile  (C-cc)
(defun tex-build-command-function (cmd &optional recenter-output-buffer
				       save-buffer override-confirm)
  "Build a TeX-command function."
  (` (lambda()
       (interactive)
       (when (, save-buffer) (save-buffer))
       (when (, recenter-output-buffer) (TeX-recenter-output-buffer nil))
       (TeX-command (, cmd) 'TeX-master-file (if (, override-confirm) 1 -1)))))
(global-set-key "\C-cc" (tex-build-command-function "LaTeX" nil t))
;;(global-set-key "\C-c <down>" 'LaTeX-environment)
(global-set-key (kbd "C-c <down>") 'LaTeX-environment)

;; F.2) Text
;;----------
(require 'generic-x)
(define-generic-mode			; need an update
    'sebText-mode ;; name of the mode to create
  '("##") ;; comments start with '##'
  '("account" "user" "password") ;; some keywords
  '(("=" . 'font-lock-operator) ;; '=' is an operator
    (";" . 'font-lock-builtin)) ;; ';' is a a built-in
  '("\\.txt$") ;; files for which to activate this mode
  nil ;; other functions to call
  "A mode for text files" ;; doc string for this mode
  )
;; see http://emacs-fu.blogspot.com/2010/04/creating-custom-modes-easy-way-with.html
;; F.3) Org-mode
;;--------------
(require 'org)
(add-to-list 'org-emphasis-alist
             '("_" (:foreground "green")
               ))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
;; agenda
(setq org-agenda-files (list "~/Computer/Emacs/org-mode/agenda/research.org"
                             "~/Computer/Emacs/org-mode/agenda/admin.org"))
;; capture notes (Ctrl-c n)
(setq org-directory "~/Computer/Emacs/org-mode/notes/")
(setq org-default-notes-file (concat org-directory "notes.org"))
(define-key global-map "\C-cn" 'org-capture)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Computer/Emacs/org-mode/notes/gtd.org" "Tasks")
	 "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/Computer/Emacs/org-mode/notes/journal.org")
	 "* %?\nEntered on %U\n  %i\n  %a")))
;; nice bullet
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; F.4) Markdown
;;--------------
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;; F.5) R
;;(ess-toggle-underscore nil)		; no more '<-' instead of _
(add-hook 'ess-mode-hook
          (lambda () 
            (ess-toggle-underscore nil)))






;;-----------------------------------------------------;;
;;              Fancy but not usued...                 ;;
;;-----------------------------------------------------;;
;;-----------
;; 1) minimap
;;-----------
;;(load "~/.emacs.d/minimap.el")
;;------------
;; 2) speedbar
;;------------
;;(load "~/.emacs.d/sr-speedbar.el")
;;(require 'sr-speedbar)
;;(defalias 'speedbar 'sr-speedbar-toggle)
;;(setq sr-speedbar-width-x 40)
;;(setq sr-speedbar-width 40)
;;(global-set-key [f7] 'speedbar) ; shortcut
;;--------------------------
;; 3) emacs with thunderbird
;;--------------------------
;;use org mode for eml files (useful for thunderbird plugin)
;;   see http://pragmaticemacs.com/emacs/use-emacs-for-thunderbird-emails/
;;(add-to-list 'auto-mode-alist '("\\.eml\\'" . org-mode))
;;----------------------------
;; 4) imenu for octave
;;--------------------
;;(setq imenu-generic-expression
;;      '((nil "\s-?\\([A-Z]\.[1-9]\).*\\)\s-*" 1)))
;;(add-hook 'octave-mode-hook
;;	  '(lambda()
;;	     (setq imenu-generic-expression
;;		   '((nil "\s-?\\([A-Z]\.[1-9]\).*\\)\s-*" 1)))
;;	     (local-set-key (kbd "C-c =") 'imenu)
;;	     ))
;;(autoload 'octave-mode "octave-mod" nil t)
;;(setq auto-mode-alist
;;      (append '(("\\.m$" . octave-mode)) auto-mode-alist)
;;----------------------------
;; 5) tabbar-ruler
;;--------------------
;; (setq tabbar-ruler-global-tabbar t)	; get tabbar
;; ;;(setq tabbar-ruler-global-ruler t)	; get global ruler
;; ;;(setq tabbar-ruler-popup-menu t)	; get popup menu.
;; ;;(setq tabbar-ruler-popup-toolbar t)	; get popup toolbar
;; ;;(setq tabbar-ruler-popup-scrollbar t)	; show scroll-bar on mouse-move
;; (require 'tabbar-ruler)
;;----------------------------
;; 6) elscreen
;;--------------------
;;(elscreen-start)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-startup-folded nil)
 '(package-selected-packages
   (quote
    (sr-speedbar yasnippet tabbar powerline org-bullets multiple-cursors magit julia-mode ido-vertical-mode avy auctex)))
 '(tabbar-separator (quote (0.75))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; bug warning
;;(setq byte-compile-warnings '(not free-vars ))

