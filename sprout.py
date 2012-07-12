import sys
from subprocess import call
from os import path, environ

if not 'PKG_SOURCE' in environ:
	raise Exception('PKG_SOURCE not defined.')
if not 'PKG_OUTPUT' in environ:
	raise Exception('PKG_OUTPUT not defined.')

#tar does not like Windows style paths.
#However, we would like to be able to use absolute paths.
DEFAULT_CMDLINES = {
	'.msi': 'msiexec /a {PKG_SOURCE_ABS} /qb! TARGETDIR="{PKG_OUTPUT_ABS}"',
	'.bz2': 'tar -xmf "{PKG_SOURCE}" -C "{PKG_OUTPUT}" --strip=1',
	'.gz':  'tar -xmf "{PKG_SOURCE}" -C "{PKG_OUTPUT}" --strip=1',
	'.zip': '7z x "{PKG_SOURCE}" -o"{PKG_OUTPUT_ABS}"',
	'.7z':  '7z x "{PKG_SOURCE}" -o"{PKG_OUTPUT_ABS}"',
	'.xpi': '7z x "{PKG_SOURCE}" -o"{PKG_OUTPUT_ABS}"'
}

pkgSource      = environ['PKG_SOURCE']
pkgSourcePosix = pkgSource
pkgSourceAbs   = path.abspath(pkgSource)
pkgOutput      = environ['PKG_OUTPUT']
pkgOutputPosix = pkgOutput
pkgOutputAbs   = path.abspath(pkgOutput)

if ('PKG_SOURCE_PSX' in environ):
	pkgSourcePosix = environ['PKG_SOURCE_PSX']
if ('PKG_OUTPUT_PSX' in environ):
	pkgOutputPosix = environ['PKG_OUTPUT_PSX']

if ('PKG_CMDLINE' in environ) and (len(environ['PKG_CMDLINE']) > 0):
	pkgCmdLine = environ['PKG_CMDLINE']
else:
	pkgSourceExt = path.splitext(pkgSource)[1]
	pkgSourceExt = pkgSourceExt.lower()
	if not (pkgSourceExt in DEFAULT_CMDLINES):
		raise Exception('Extension {} is not supported. ' +
			'Please provide PKG_CMDLINE'.format(pkgSourceExt))
	pkgCmdLine = DEFAULT_CMDLINES[pkgSourceExt]

pkgCmdLine = pkgCmdLine.format(
	PKG_SOURCE     = pkgSource,
	PKG_SOURCE_PSX = pkgSourcePosix,
	PKG_SOURCE_ABS = pkgSourceAbs,
	PKG_OUTPUT     = pkgOutput,
	PKG_OUTPUT_PSX = pkgOutputPosix,
	PKG_OUTPUT_ABS = pkgOutputAbs
)

print(pkgCmdLine)
print('>> Execution is being deferred to an external application.')
print('   This might take a while and it is likely that no output is shown.')
exitCode = call(pkgCmdLine, shell = True)
print('<< Execution returned.')
if (exitCode != 0):
	sys.exit(exitCode)
