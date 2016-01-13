" **************************************************************************** "
"                                                                              "
"                                                    ____     _ __             "
"    EPIheader.vim                                  / __/___ (_) /____ _       "
"                                                  / _// _  / / __/ _ `/       "
"    By: simon_h <nicolas1.simon@epita.fr>        /___/ ,__/_/\__/\_,_/        "
"                                                    /_/.eu                    "
"    Created: 2015/12/09 12:35:03 by simon_h                                   "
"    Updated: 2016/01/13 17:21:53 by login_x                                   "
"                                                                              "
" **************************************************************************** "

function s:trimlogin ()
	let l:USER = "login_x"
	let l:trimlogin = strpart(USER, 0, 9)
	return l:trimlogin
endfunction

function s:trimemail ()
	let l:MAIL = "last.name@epita.fr"
	let l:trimemail = strpart(MAIL, 0, s:contentlen - 16)
	return l:trimemail
endfunction

let s:asciiart = [
\"   ____     _ __         ",
\"  / __/___ (_) /____ _   ",
\" / _// _  / / __/ _ `/   ",
\"/___/ ,__/_/\\__/\\_,_/    ",
\"   /_/.eu                ",
\"                         ",
\"                         "]

let s:styles = [
			\{
			\'extensions': ['\.c$', '\.h$', '\.cc$', '\.hh$', '\.cpp$', '\.hpp$', '\.cs$'],
			\'start': '/*', 'end': '*/', 'fill': '*'
			\},
			\{
			\'extensions': ['\.htm$', '\.html$', '\.xml$'],
			\'start': '<!--', 'end': '-->', 'fill': '*'
			\},
			\{
			\'extensions': ['\.js$'],
			\'start': '//', 'end': '//', 'fill': '*'
			\},
			\{
			\'extensions': ['\.tex$'],
			\'start': '%', 'end': '%', 'fill': '*'
			\},
			\{
			\'extensions': ['\.ml$', '\.mli$', '\.mll$', '\.mly$'],
			\'start': '(*', 'end': '*)', 'fill': '*'
			\},
			\{
			\'extensions': ['\.vim$', 'vimrc$', '\.myvimrc$', 'vimrc$'],
			\'start': '"', 'end': '"', 'fill': '*'
			\},
			\{
			\'extensions': ['\.el$', '\.emacs$', '\.myemacs$'],
			\'start': ';', 'end': ';', 'fill': '*'
			\},
			\{
			\'extensions': ['\.f90$', '\.f95$', '\.f03$', '\.f$', '\.for$'],
			\'start': '!', 'end': '!', 'fill': '/'
			\}
			\]

let s:linelen		= 80
let s:marginlen		= 5
let s:contentlen	= s:linelen - (3 * s:marginlen - 1) - strlen(s:asciiart[0])

function s:midgap ()
	return repeat(' ', s:marginlen - 1)
endfunction

function s:lmargin ()
	return repeat(' ', s:marginlen - strlen(s:start))
endfunction

function s:rmargin ()
	return repeat(' ', s:marginlen - strlen(s:end))
endfunction

function s:empty_content ()
	return repeat(' ', s:contentlen)
endfunction

function s:left ()
	return s:start . s:lmargin()
endfunction

function s:right ()
	return s:rmargin() . s:end
endfunction

function s:bigline ()
	return s:start . ' ' . repeat(s:fill, s:linelen - 2 - strlen(s:start) - strlen(s:end)) . ' ' . s:end
endfunction

function s:logo1 ()
	return s:left() . s:empty_content() . s:midgap() . s:asciiart[0] . s:right()
endfunction

function s:fileline ()
	let l:trimfile = strpart(fnamemodify(bufname('%'), ':t'), 0, s:contentlen)
	return s:left() . l:trimfile . repeat(' ', s:contentlen - strlen(l:trimfile)) . s:midgap() . s:asciiart[1] . s:right()
endfunction

function s:logo2 ()
	return s:left() . s:empty_content() . s:midgap() .s:asciiart[2] . s:right()
endfunction

function s:coderline ()
	let l:contentline = "By: ". s:trimlogin () . ' <' . s:trimemail () . '>'
	return s:left() . l:contentline . repeat(' ', s:contentlen - strlen(l:contentline)) . s:midgap() . s:asciiart[3] . s:right()
endfunction

function s:logo3 ()
	return s:left() . s:empty_content() . s:midgap() .s:asciiart[4] . s:right()
endfunction

function s:dateline (prefix, logo)
	let l:date = strftime("%Y/%m/%d %H:%M:%S")
	let l:contentline = a:prefix . ": " . l:date . " by " . s:trimlogin ()
	return s:left() . l:contentline . repeat(' ', s:contentlen - strlen(l:contentline)) . s:midgap() . s:asciiart[a:logo] . s:right()
endfunction

function s:createline ()
	return s:dateline("Created", 5)
endfunction

function s:update2line ()
	return s:dateline("Updated", 6)
endfunction

function s:emptyline ()
	return s:start . repeat(' ', s:linelen - strlen(s:start) - strlen(s:end)) . s:end
endfunction

function s:filetype2 ()
	let l:file = fnamemodify(bufname("%"), ':t')

	let s:start = '#'
	let s:end = '#'
	let s:fill = '-'

	for l:style in s:styles
		for l:ext in l:style['extensions']
			if l:file =~ l:ext
				let s:start = l:style['start']
				let s:end = l:style['end']
				let s:fill = l:style['fill']
			endif
		endfor
	endfor
endfunction

function s:insert2 ()
	call s:filetype2 ()

	call append(0, "")
	call append (0, s:bigline())
	call append (0, s:emptyline())
	call append (0, s:update2line())
	call append (0, s:createline())
	call append (0, s:logo3())
	call append (0, s:coderline())
	call append (0, s:logo2())
	call append (0, s:fileline())
	call append (0, s:logo1())
	call append (0, s:emptyline())
	call append (0, s:bigline())
endfunction

function s:update2 ()
	call s:filetype2 ()

	let l:pattern = s:start . repeat(' ', 5 - strlen(s:start)) . "Updated: [0-9]"
	let l:line = getline (9)

	if l:line =~ l:pattern
		call setline(9, s:update2line())
	endif
endfunction

command Epiheader call s:insert2 ()
nmap <F3> :Epiheader<CR>
autocmd BufWritePre * call s:update2 ()
