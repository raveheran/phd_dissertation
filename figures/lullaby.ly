\version "2.18.2"

\include "snippet_layout.ly"

melody = \relative c'' {
  \clef treble
  \key c \major
  \time 6/8

  \override Score.BarNumber.break-visibility = ##(#f #t #t)
  \set Score.markFormatter = #format-mark-box-alphabet

  \mark \default
  g4 e8 g4. g4 e8 \slashedGrace a8 g4. g4 e8 g4 e8 d4.~ d4.
  g4 e8 g4. g4 e8 \slashedGrace a8 g4. g4 e8 d4 e16 d c4.~ c4.
  
  \mark \default
  a'4 a8 c4 a8 g4 e8 e4. g4 e8 d4 c8 \slashedGrace e8 d4.~ d4.
  a'4 a8 c4 a8 g4 e8 e4. g4 e8 d4 e16 d c4.~ c4. \bar ":|]"
}

\score {
  <<
    \new Staff \transpose c b, {\melody}
  >>
  \layout{ }
  \midi { }
}