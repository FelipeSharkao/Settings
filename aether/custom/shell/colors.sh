printf '\e]4;0;%s\a'   '{color0}'
printf '\e]4;1;%s\a'   '{color1}'
printf '\e]4;2;%s\a'   '{color2}'
printf '\e]4;3;%s\a'   '{color3}'
printf '\e]4;4;%s\a'   '{color4}'
printf '\e]4;5;%s\a'   '{color5}'
printf '\e]4;6;%s\a'   '{color6}'
printf '\e]4;7;%s\a'   '{color7}'
printf '\e]4;8;%s\a'   '{color8}'
printf '\e]4;9;%s\a'   '{color9}'
printf '\e]4;10;%s\a'  '{color10}'
printf '\e]4;11;%s\a'  '{color11}'
printf '\e]4;12;%s\a'  '{color12}'
printf '\e]4;13;%s\a'  '{color13}'
printf '\e]4;14;%s\a'  '{color14}'
printf '\e]4;15;%s\a'  '{color15}'

printf '\e]4;256;%s\a' '{accent}' # bold
printf '\e]4;257;%s\a' '{accent}' # underline

printf '\e]10;%s\a'    '{foreground}'
printf '\e]11;%s\a'    '{background}'
printf '\e]12;%s\a'    '{cursor}'

printf '\e]17;%s\a'    '{selection_background}'
printf '\e]19;%s\a'    '{selection_foreground}'
