\version "2.18.2"

\include "snippet_layout.ly"

\relative c' {
	\stopStaff
	\override Staff.Clef #'stencil = ##f
	\override Staff.TimeSignature #'stencil = ##f
	%\override MetronomeMark.font-size = #8
	\tempo 4 = 120
}