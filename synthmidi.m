%
%    Octave stringed instument sythesis
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

function y=synthmidi(midifile, tracks)
  midi=readmidi(midifile);

  notes=midinotes(midi, tracks);

  fs=44100; % Sampling frequency
  tempo=120; % beats per minute
  beat_unit=4; % The bottom number of the signature (4 means quarter note is one beat)
  division=midi.ticks_per_quarter_note; % MIDI ticks per quater note
    
  time_scaling=beat_unit/(4*tempo*division);
  time_scaling=time_scaling*60; % Convert to seconds

  num_samples=0;
  for i=1:size(notes,1)
    ni2=floor(notes(i,4)*time_scaling*fs+0.5);
    if ni2>num_samples
      num_samples=ni2;
    endif
  endfor

  y=zeros(1,num_samples);
  for i=1:size(notes,1)
    nn=notes(i,1);
    ni1=floor(notes(i,3)*time_scaling*fs+0.5);
    ni2=floor(notes(i,4)*time_scaling*fs+0.5);
    f=440*(2^((nn-69)/12)); % Convert MIDI note number to frequency, eg. 69 to 440Hz
    yks=ks_synth(f,ni2-ni1,fs)*notes(i,2);
    y(ni1+1:ni2)=y(ni1+1:ni2)+yks;
  endfor

endfunction

function notes=midinotes(midi, tracks)
  
  % Allocate an array for notes based on number of messages, truncate later
  num_messages=0;
  for track=tracks;
    num_messages=num_messages+length(midi.track(track).messages);
  endfor
  notes=zeros(num_messages,4);
  
  % Get the notes from each track
  note_cnt=0;
  for track=tracks;
    m=midi.track(track).messages;
    time=0;
    note_vel=zeros(1,128);
    note_time_start=zeros(1,128);
    for i=1:length(m)
      deltatime=m(i).deltatime;
      time=time+deltatime;
      type=[m(i).type]';
      data=[m(i).data]';
      if (type==144 && data(2)>0)
        nn=data(1);
        if note_vel(nn)==0 % If note is not already on
          note_vel(nn)=data(2);
          note_time_start(nn)=time;
        endif
      elseif ((type==128) || (type==144 && data(2)==0))
        nn=data(1);
        if note_vel(nn) % If note was on
          note_cnt=note_cnt+1;
          notes(note_cnt,:)=[nn note_vel(nn) note_time_start(nn) time];
          note_vel(nn)=0;
        endif
      endif
    endfor   
  endfor
  notes=notes(1:note_cnt,:); % Trim note array, we over allocated above

endfunction