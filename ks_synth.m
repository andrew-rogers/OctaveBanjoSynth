%
%    Octave stringed instument sythesis - an implementation of the Karplus-Strong algorithm
%    Copyright (C) 2018  Andrew Rogers
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License along
%    with this program; if not, write to the Free Software Foundation, Inc.,
%    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%

function y=ks_synth(f,n,fs)
  if nargin<3
    fs=44100;
  end
  if nargin<2
    n=10*fs; % Default to 10 seconds
  end
  if nargin<1
    f=220; % Default to 220Hz 'A'
  end
  delay=floor(fs/f+0.5);
  excitation=[rand(1,delay)-0.5 zeros(1,n-delay)];
  y=filter(1,[1 zeros(1,delay) -0.25 -0.5 -0.25],excitation);
endfunction
