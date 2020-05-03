\version "2.18.2"

\include "snippet_layout.ly"

\relative c'' {
	\stopStaff
	\override Staff.Clef #'stencil = ##f
	\override Staff.TimeSignature #'stencil = ##f
	cisih
}