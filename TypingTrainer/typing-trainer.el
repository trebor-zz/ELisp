;;;; header 
;; $Header:$ 

;;;;; typing 

(defun robert-pause-no-input (secs)
  "sleep, discard all inputs afterwards"
  (sleep-for secs)
  (while 
      (read-char "" nil 0.0001)))

(defun robert-read-in-time (prompt secs)
  "read-char, but return after <secs>"
  (let* ((t1 (float-time))
	 (char (read-char prompt nil secs))
	 (t-read (- (float-time) t1)))
    (robert-pause-no-input (- secs t-read))
    char))
;;(robert-read-in-time "test" 3.0)    


(defun robert-buffer-kill+clear (bufname)
  (save-window-excursion
    (switch-to-buffer bufname)
    (kill-buffer bufname))
  (switch-to-buffer-other-window bufname))

(defun robert-typing-test (line time-pause time-delta pause)
    (blink-cursor-mode)
    (robert-buffer-kill+clear "=type-trainer=")
  (let ((indent-string "          ")
	(from-string " _:_")
	(to-string " _|_")
	(move-string "  _:_") )
    (insert "\n\n\n\n\n" indent-string from-string "\n")
    (insert indent-string "  " line "  \n")
    (goto-char (point-min))
    (internal-show-cursor nil nil)
    (let ((result
	   (loop	    
	    for i from (- (length line))
	    for time-wait = time-pause then (- (+ time-pause time-delta) 
					       (- (float-time) ti))
	    for t0l = (robert-pause-no-input time-wait )
	    for ti = (float-time)
	    for cursor = (or (search-forward from-string nil t 1) (point-max))
	    for pos-in-line = (- cursor (point-at-bol) 2)
	    for pos-bel = (point-at-bol)
	    for goal-string = (progn
				(replace-match to-string)
				;;(next-line)
				(redisplay)
				(goto-char (+ pos-in-line (point-at-bol 2)))
				(char-to-string (char-after)))
	    for play-tick = (ignore-errors 
			      (play-sound (list 'sound :file
						(concat
						"/home/DKI/gloecr/temp/"
						"Click-Sounds/"
						"54406__KorgMS2000B__Metronome_Click.wav"))))
	    for typed-string = (char-to-string 
				(or (robert-read-in-time 
				     (format  "%d Drücke die Taste: >%s<" i goal-string) 
				     time-delta)
				    0))
	    for repl-string = (if (string-equal goal-string typed-string)
				  move-string
				from-string)
	    do (progn 
		 (forward-line -3)
		 (when (search-forward to-string nil nil 1)
		   (replace-match repl-string)) 
		 (redisplay t)
		 (forward-line -3))
	    until (= pos-in-line (+ 2 (length indent-string) (length line)))
	    finally (return i))))
      (internal-show-cursor nil t)
      (read-char (format "Fehler: %d" result ) nil pause)
      (kill-buffer "=type-trainer=")
      result)))



;;;;; temp
(let* ((bufname "=type-trainer=")
       (indent-x "          ")
       (indent-y "\n\n\n\n\n\n")
       (line "asdf jkl;")
       pos-mark
       pos-line
       )
  (save-window-excursion
    (switch-to-buffer bufname)
    (overwrite-mode 1)
    (insert (concat indent-y indent-x))
    (setq pos-mark (point))
    (insert ":\n")
    (insert (concat indent-x line "\n"))
    ))



(robert-let* ((no-input (char-to-string (robert-pause-no-input 10.0)))
	      (real-input (char-to-string 
			   (or (robert-read-in-time "press something" 5.0)
			       ?@)
			       ) ))
	     )

       

;;;;; testing


(robert-typing-test "asdf jkl asdf jkl" 1.0)

(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 3.0 1.0 5.0)
(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 0.5 1.0 5.0)
(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 0.4 0.8 5.0)
(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 0.3 0.6 5.0)
(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 0.4 0.3 5.0)
(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 0.2 0.4 5.0)
(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 0.3 0.3 5.0)
(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 0.1 0.3 5.0)
(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 0.1 0.2 5.0)
(robert-typing-test "ffjj ffjj ffjj ffjj ffjj fjfj fjfj fjfj jjff jjff jfjf jfjf fjfj ddkk ddkk" 0.1 0.1 5.0)



;;;; local variables 


;; Local Variables:
;; buffer-file-coding-system: unix
;; mode: emacs-lisp
;; mode: eldoc
;; mode: outline-minor
;; outline-regexp: ";;;;+ "
;; outline-regexp-short: ";;;;+ "
;; outline-regexp-long:  ";;;\\(;* [^ 	\n]\\|###autoload\\)\\|("
;; outline-heading-1: ";;;; "
;; outline-heading-2: ";;;;;+ "
;; mode: robert-outline-highlight
;; End:

