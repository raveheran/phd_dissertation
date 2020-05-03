\version "2.18.2"

\include "snippet_layout.ly"

\new StaffGroup <<
\new RhythmicStaff {
	c4 c8 c4.
}
	\key aes \major
	\time 6/8
	\once \override Staff.TimeSignature #'stencil = ##f
	
	\override Score.BarNumber.break-visibility = ##(#f #t #t)
	\set Score.currentBarNumber = #10
	\bar ""
	\transpose c aes \relative c'
	{ e4 \xNotesOn d16 c \xNotesOff c4. }
	
	\\

	\hide Stem
	\transpose c aes \relative c''
	{ \teeny g4 e8 e4 }
>>