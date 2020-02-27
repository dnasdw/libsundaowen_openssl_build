IF DEFINED VS90COMNTOOLS (
  SET VCVARSALL="%VS90COMNTOOLS%..\..\VC\vcvarsall.bat"
) ELSE IF DEFINED VS120COMNTOOLS (
  SET VCVARSALL="%VS120COMNTOOLS%..\..\VC\vcvarsall.bat"
) ELSE IF DEFINED VS110COMNTOOLS (
  SET VCVARSALL="%VS110COMNTOOLS%..\..\VC\vcvarsall.bat"
) ELSE IF DEFINED VS100COMNTOOLS (
  SET VCVARSALL="%VS100COMNTOOLS%..\..\VC\vcvarsall.bat"
)
SET target_lib_suffix=
IF NOT DEFINED VCVARSALL (
  ECHO Can not find VC2008 or VC2010 or VC2012 or VC2013 installed!
  GOTO ERROR
)
CALL %VCVARSALL% x86
@ECHO ON
PUSHD "%~dp0"
SET tmpdir=%~d0\tmp_libsundaowen_openssl
SET target=windows_x86_32
SET prefix=%tmpdir%\%target%
SET openssldir=%prefix%\ssl
SET /P version=<version.txt
RD /S /Q "%tmpdir%\%version%"
MD "%tmpdir%\%version%"
XCOPY "..\%version%" "%tmpdir%\%version%" /S /Y
PUSHD "%tmpdir%\%version%"
perl Configure VC-WIN32 no-shared no-asm --prefix="%prefix%" --openssldir="%openssldir%"
nmake
nmake install
POPD
MD "..\target\include\%target%"
XCOPY "%prefix%\include" "..\target\include\%target%" /S /Y
MD "..\target\lib\%target%%target_lib_suffix%"
COPY /Y "%prefix%\lib\*.lib" "..\target\lib\%target%%target_lib_suffix%"
POPD
RD /S /Q "%tmpdir%"
GOTO :EOF

:ERROR
PAUSE
