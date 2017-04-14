--for i,v in pairs(manager:machine().devices) do print(i) end;
snd = manager:machine().devices[":taito_en:audiocpu"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":screen"]

--dofile("notes.lua")--musical notes
--dofile("asciitable.lua")--hex2text

gtranspose = -23

Addresses = {
0x59CE,0x5996,0x595E,0x5926,
0x58EE,0x587E,0x5846,
0x580E,0x57D6,0x579E,0x5766,
0x5D4E

}
playkx = {
  0, --C   1
  2, --C#  2
  4, --D   3
  6, --D#  5
  8, --E   5
 12, --F   6
 14, --F#  7
 16, --G   8
 18, --G#  9
 20, --A  10
 22, --A# 11
 24, --B  12
 28, --C  13
 30, --C# 14
 32, --D  15
 34, --D# 16
 36, --E  17
 40, --F  18
 42, --F# 19
 44, --G  20
 46, --G# 21
 48, --A  22
 50, --A# 23
 52, --B  24
 56, --C  25
 58, --C# 26
 60, --D  27
 62, --D# 28
 64, --E  29
 68, --F  30
 70, --F# 31
 72, --G  32
 74, --G# 33
 76, --A  34
 78, --A# 35
 80, --B  36
 84, --C  37
 86, --C# 38
 88, --D  39
 90, --D# 40
 92, --E  41
 96, --F  42
 98, --F# 43
100, --G  44
102, --G# 45
104, --A  46
106, --A# 47
108, --B  48
112, --C  49
114, --C# 50
116, --D  51
118, --D# 52
120, --E  53
124, --F  54
126, --F# 55
128, --G  56
130, --G# 57
132, --A  58
134, --A# 59
136, --B  60 
140, --C  61
142, --C# 62
144, --D  63
146, --D# 64
148, --E  65
152, --F  66
154, --F# 67
156, --G  68
158, --G# 69
160, --A  70
162, --A# 71
164, --B  72
168, --C  72
170, --C# 73
172, --D  74
174, --D# 75
176, --E  76
180, --F  77
182, --F# 78
184, --G  79
186, --G# 80
188, --A  81
190, --A# 82
192, --B  83
196, --C  84

}
--84

playky = {
  4, --C   1
  1, --C#  2
  4, --D   3
  1, --D#  4
  4, --E   5
  4, --F   6
  1, --F#  7
  4, --G   8
  1, --G#  9
  4, --A  10
  1, --A# 11
  4, --B  12
  4, --C  13
  1, --C# 14
  4, --D  15
  1, --D# 16
  4, --E  17
  4, --F  18
  1, --F# 19
  4, --G  20
  1, --G# 21
  4, --A  22
  1, --A# 23
  4, --B  24
  4, --C  25
  1, --C# 26
  4, --D  27
  1, --D# 28
  4, --E  29
  4, --F  30
  1, --F# 31
  4, --G  32
  1, --G# 33
  4, --A  34
  1, --A# 35
  4, --B  36
  4, --C  37
  1, --C# 38
  4, --D  39
  1, --D# 40
  4, --E  41
  4, --F  42
  1, --F# 43
  4, --G  44
  1, --G# 45
  4, --A  46
  1, --A# 47
  4, --B  48
  4, --C  49
  1, --C# 50
  4, --D  51
  1, --D# 52
  4, --E  53
  4, --F  54
  1, --F# 55
  4, --G  56
  1, --G# 57
  4, --A  58
  1, --A# 59
  4, --B  60
  4, --C  61
  1, --C# 62
  4, --D  63
  1, --D# 64
  4, --E  65
  4, --F  66
  1, --F# 67
  4, --G  68
  1, --G# 69
  4, --A  70
  1, --A# 71
  4, --B  72
  4, --C  73
  1, --C# 74
  4, --D  75
  1, --D# 76
  4, --E  77
  4, --F  78
  1, --F# 79
  4, --G  80
  1, --G# 81
  4, --A  82
  1, --A# 83
  4, --B  84
  4, --C  85

}



--[[
Notes
14bda6 Kazuya data

]]

function main()
--print("main")
measure = mem:read_u16(0xFFD0B0)
beat = mem:read_u16(0xFFD0B2)+1
tempo = mem:read_u16(0xFFD0E6)

ascii(0xFFD06C-1,15,0,0)--Songname
gui:draw_box(0,10,38,18,0xC00000EE,0xFFFFFFFF)
gui:draw_text(2,9,string.format("Metro: %d",beat))
gui:draw_box(38,10,88,18,0xC00000EE,0xFFFFFFFF)
gui:draw_text(40,9,string.format("Measure: %02d",measure))
gui:draw_box(0,18,46,26,0xC00000EE,0xFFFFFFFF)
gui:draw_text(2,18,string.format("Tempo: %d",tempo))

if 0xFFD06C ~= 0 then
playkeyboard(0x00,0, 100)
playkeyboard(0x01,0, 110)
playkeyboard(0x02,0, 120)
playkeyboard(0x03,0, 130)
playkeyboard(0x04,0, 140)
playkeyboard(0x05,0, 150)
playkeyboard(0x06,0, 160)
playkeyboard(0x07,0, 170)
end

end

function ascii(addr,length,x,y)
gui:draw_box(x,y,x+128,y+10,0xC0EE00DD,0xFFFFFFFF)
for text = 0,length,1 do
	addr = addr + 1
--	textp1 = mem:read_u8(addr)
--	ftext = asciitable[textp1+1]
--	gui:draw_text(2+x+text*8,y,ftext)
	end
end

function drawkeyboard(kbx,kby,octaves)
WKeysC1,WKeysC2 = 0xFFFFFFFF,0xFFAAAAAA
BKeysC1,BKeysC2 = 0xFF000000,0xFF777777
--BG
for oct = 0,octaves,1 do
for wk = 0,6,1 do --WhiteKeys
gui:draw_box(oct*28+kbx+wk*4,kby,oct*28+kbx+3+wk*4,kby+7,WKeysC1,WKeysC2)
end

for bd = 0,1,1 do
gui:draw_box(oct*28+kbx+2+bd*4,kby,oct*28+kbx+5+bd*4,kby+4,BKeysC1,BKeysC2)
end

for bt = 0,2,1 do
gui:draw_box(oct*28+kbx+14+bt*4,kby,oct*28+kbx+17+bt*4,kby+4,BKeysC1,BKeysC2)
end
end
end

function playkeyboard(id,x,y)
addr = Addresses[id+1]
note1  = mem:read_u8(addr + 0x22)
play = mem:read_u16(addr + 0x24)

--if active ~= 0 then
gui:draw_box(x,y,x+240,y+10,0xFF0000FF,0xFFFFFF00)
gui:draw_text(x + 02,y + 2,string.format("%04X",addr))
drawkeyboard(x+40,y+2,6)

if play ~= 0 then
	--gui:draw_text(x + 20,y + 2,cps2notes[note1])
	drawplaynote(note1 + gtranspose,x+40,y+2,0xFFFF0000,0xFF880000)
end

end


function rd24bit(adr8,adr16)
val8  = mem:read_u8(adr8)
val16 = mem:read_u16(adr16)

val = (val8*0x10000) + val16

return val
end

function drawplaynote(mnote,x,y,color1,color2)
print(mnote)
x1 = x + playkx[mnote]
y1 = y + playky[mnote]
x2 = 3 + x1
y2 = 3 + y1

gui:draw_box(x1,y1,x2,y2,color1,color2)

end

--emu.sethook(main,"frame")
emu.register_frame_done(main)
