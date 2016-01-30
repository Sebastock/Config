;; Tabbar-mode un peu customizer
;;------------------------------
(when (require 'tabbar nil t)
  (setq tabbar-buffer-groups-function
    	(lambda () (list "All Buffers")))
  (setq tabbar-buffer-list-function
    	(lambda ()
    	  (remove-if
    	   (lambda(buffer)
    	     (find (aref (buffer-name buffer) 0) " *"))
    	   (buffer-list))))
  (tabbar-mode))
;; Tabbar
(require 'tabbar)
;; Tabbar settings
(set-face-attribute
 'tabbar-default nil
 :background "gray20"
 :foreground "gray20"
 :box '(:line-width 1 :color "gray20" :style nil))
(set-face-attribute
 'tabbar-unselected nil
 :background "gray30"
 :foreground "white"
 :box '(:line-width 5 :color "gray30" :style nil))
(set-face-attribute
 'tabbar-selected nil
 :background "gray75"
 :foreground "black"
 :box '(:line-width 5 :color "gray75" :style nil))
(set-face-attribute
 'tabbar-highlight nil
 :background "white"
 :foreground "black"
 :underline nil
 :box '(:line-width 5 :color "white" :style nil))
(set-face-attribute
 'tabbar-button nil
 :box '(:line-width 1 :color "gray20" :style nil))
(set-face-attribute
 'tabbar-separator nil
 :background "gray20"
 :height 0.6)
;; 
;; Nice! ('M-x customize' to find the name of the font)
(set-face-attribute
 'tabbar-modified nil
 :background "gray30"
 :foreground "yellow"
;; :height 1.1
 :height 135
 :font "Ubuntu mono"
 :box '(:line-width 1 :color "gray20" :style nil))

;; Raccourcis clavier pour changer de buffer
(global-set-key [\C-tab] 'tabbar-forward-tab)
(global-set-key (kbd "<C-S-iso-lefttab>") 'tabbar-backward-tab)
(global-set-key [C-next] 'tabbar-forward-tab)
(global-set-key [C-prior] 'tabbar-backward-tab)
;; add space between name
(setq tabbar-tab-label-function
      (lambda (tab) (tabbar-shorten (format " %s " (car tab)) 20))) ;(lambda (tab) (format " %s " (car tab)))
;; add space tab
(custom-set-variables
 '(tabbar-separator (quote (0.75))))
