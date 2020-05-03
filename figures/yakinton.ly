\version "2.18.2"

\include "snippet_layout.ly"

melody = \relative c' {
  \clef treble
  \key d \major
  \time 2/4

  \override Score.BarNumber.break-visibility = ##(#f #t #t)
  \set Score.markFormatter = #format-mark-box-alphabet

  \mark \default
  d8\( fis a fis		e d b d		e-. e16 fis d4\) \breathe
  d8\( fis a fis		b a e fis	a-. \parenthesize a16 e a4\)   \breathe
  
  \mark \default
  e16( fis) g8 e16( fis) g8		a-_ a-_ fis4		\breathe
  d16( e) fis8 d16( e) fis8		fis( e) b4
  
  \mark \default
  a8\( d e fis		e d b d		e-. e16 fis d4\) \bar "|."
}

harmonies = \chordmode {
  d2:maj g2	a4:7 d4:maj
  d2:maj b4:7 e4:m a2/b
  e2:m a4:7 d4 b2:m e4:7 a4:7
  d2:maj g2	a4:7 d4:maj
}

\score {
  <<
    \new ChordNames {
      \set chordChanges = ##t
      \transpose d b, {\harmonies}
    }
    \new Staff \transpose d b, {\melody}
  >>
  \layout{ }
  \midi { }
}