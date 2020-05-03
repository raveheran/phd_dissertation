\version "2.18.2"

\include "lilypond-book-preamble.ly"

\include "snippet_layout.ly"

\new StaffGroup <<
\new RhythmicStaff {
\override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/1)
	c4 c8 c4 c16 c		c4.~ c4.
}
	\key bes \major
	\time 6/8
	\once \override Staff.TimeSignature #'stencil = ##f
	
	\override Score.BarNumber.break-visibility = ##(#f #t #t)
	\set Score.currentBarNumber = #15
	\bar ""
	\transpose c bes \relative c'
	{ gih4 disih8 d4 \xNotesOn c8 \xNotesOff		\xNotesOn \slashedGrace d8 \xNotesOff c4.~ c4. }
	
	\\

	\hide Stem
	\transpose c bes \relative c'
	{\teeny \hideNotes g4  \unHideNotes \hide Stem e8 \hideNotesd4  \hide Stem e16 d	\hideNotes c4.~ c4.}
>>