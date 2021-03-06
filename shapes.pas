{Copyright (C) 2018 Yevhen Loza

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.}

{---------------------------------------------------------------------------}

(* Predefined shapes than can be assigned to Figures *)

{$INCLUDE compilerconfig.inc}

unit Shapes;

interface

{ Shapes are taken from:
  https://bitstorm.org/gameoflife/
  https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
  http://www.conwaylife.com/wiki/Category:Patterns_with_(number)_cells

  todo:
  http://www.conwaylife.com/wiki/Eater_1
  8 cells and higher
}

type
  TShape = record
    SizeX, SizeY: integer;
    FArray: array of array of boolean;
  end;

function GliderShape: TShape;
function NineShape: TShape;
function SolarPanelShape: TShape;
function SolarArrayShape: TShape;
function ToadShape: TShape;
function BeaconShape: TShape;
function ClockShape: TShape;
function BaseUnpackerShape: TShape;
function LWSSShape: TShape;
function Line10Shape: TShape;
function TumblerShape: TShape;
function GosperGunShape: TShape;
implementation

{ basic game shapes placable on the battlefield
  reference of array indexes is inverse: Y-X }
const
  { a main attack force, cheap and small
    Flight speed: 1 tile per 4 turns diagonal}
  Glider: array [0..2,0..2] of byte = ((0,1,0),(0,0,1),(1,1,1));
  { a combined defence/offence unit
    evolves into a glider and a block }
  Nine: array [0..3,0..2] of byte =
    ((1,0,0),
     (1,0,0),
     (1,0,1),
     (0,1,1));

  { a main power generator
    Period : 2}
  SolarPanel: array [0..0,0..2] of byte = ((1,1,1));
  { main productive force with 4 solar panels
    Unwraps in 9 turns}
  SolarArray: array [0..1,0..2] of byte = ((0,1,0),(1,1,1));

  { Influence generators
    Period : 2}
  Toad: array [0..3, 0..3] of byte =
    ((0,0,1,0),
     (1,0,0,1),
     (1,0,0,1),
     (0,1,0,0));
  Beacon: array [0..3, 0..3] of byte =
    ((1,1,0,0),
     (1,0,0,0),
     (0,0,0,1),
     (0,0,1,1));
  Clock: array [0..3, 0..3] of byte =
    ((0,1,0,0),
     (0,0,1,1),
     (1,1,0,0),
     (0,0,1,0));
  { a powerful core with 4 (1/3 effective) solar panels
    Unwraps in 26 turns
    Period: 3 }
  BaseUnpacker: array [0..4,0..4] of byte =
    ((1, 0, 1, 0, 1),
     (1, 0, 0, 0, 1),
     (1, 0, 0, 0, 1),
     (1, 0, 0, 0, 1),
     (1, 0, 1, 0, 1));
  { a powerful attack unit
    Flight speed: 2 tiles per 4 turns rectagonal }
  LWSS: array [0..3,0..4] of byte =
    ((0, 1, 1, 1, 1),
     (1, 0, 0, 0, 1),
     (0, 0, 0, 0, 1),
     (1, 0, 0, 1, 0));

  { Large oscillator (with a few solar panels) }
  Line10: array [0..0,0..9] of byte = ((1,1,1,1,1,1,1,1,1,1));
  { Tumbler - just a useless oscillator }
  Tumbler: array [0..5,0..6] of byte =
    ((0,1,1,0,1,1,0),
     (0,1,1,0,1,1,0),
     (0,0,1,0,1,0,0),
     (1,0,1,0,1,0,1),
     (1,0,1,0,1,0,1),
     (1,1,0,0,0,1,1));

  { extreme attack force for the enemy
    Fires sequential gliders (first one at turn 73) each 32 turns }
  GosperGun: array [0..14,0..37] of byte =
    ((0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,1,0,0),
     (1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
     (1,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0),
     (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0));

function GliderShape: TShape;
const
  sx = 3;
  sy = 3;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := Glider[iy, ix] = 1;
  end;
end;

//Nine: array [0..3,0..2]
function NineShape: TShape;
const
  sx = 3;
  sy = 4;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := Nine[iy, ix] = 1;
  end;
end;

//[0..0,0..2]
function SolarPanelShape: TShape;
const
  sx = 3;
  sy = 1;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := SolarPanel[iy, ix] = 1;
  end;
end;

//[0..1,0..2]
function SolarArrayShape: TShape;
const
  sx = 3;
  sy = 2;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := SolarArray[iy, ix] = 1;
  end;
end;


function ToadShape: TShape;
const
  sx = 4;
  sy = 4;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := Toad[iy, ix] = 1;
  end;
end;


function BeaconShape: TShape;
const
  sx = 4;
  sy = 4;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := Beacon[iy, ix] = 1;
  end;
end;

function ClockShape: TShape;
const
  sx = 4;
  sy = 4;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := Clock[iy, ix] = 1;
  end;
end;

function BaseUnpackerShape: TShape;
const
  sx = 5;
  sy = 5;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := BaseUnpacker[iy, ix] = 1;
  end;
end;

function LWSSShape: TShape;
const
  sx = 5;
  sy = 4;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := LWSS[iy, ix] = 1;
  end;
end;

function Line10Shape: TShape;
const
  sx = 10;
  sy = 1;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := Line10[iy, ix] = 1;
  end;
end;

function TumblerShape: TShape;
const
  sx = 6;
  sy = 7;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := Tumbler[iy, ix] = 1;
  end;
end;

function GosperGunShape: TShape;
const
  sx = 38;
  sy = 15;
var
  ix, iy: integer;
begin
  Result.SizeX := sx;
  Result.SizeY := sy;
  SetLength(Result.FArray, sx);
  for ix := 0 to Pred(sx) do
  begin
    SetLength(Result.FArray[ix], sy);
    for iy := 0 to Pred(sy) do
      Result.FArray[ix, iy] := GosperGun[iy, ix] = 1;
  end;
end;

end.

