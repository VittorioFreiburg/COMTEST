## Copyright (C) 2021 vitto
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.
##
## This function creates a structure with the PI(s) associated with the PRTS stimulus
## s = PRTSinfo (t,BS)
##
## Author: vitto <vitto@LAPTOP-87C2F1J9>
## Created: 2021-03-12

function s = PRTSinfo (BS)
%% compute FRF s.FRF
%              s.Gain
%              s.Phase


%% compute human likeliness measure on the basis of reference human data
m=[0 0 0 0 0 0 0 0 0 0 0];
S=[0 0 0 0 0 0 0 0 0 0 0];
d= FRF-m;
D=sqrt(d*S*W*S'*d');

endfunction
