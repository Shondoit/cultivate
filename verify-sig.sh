#!/bin/sh

### Require at least a signature file, a file to verify and one or more keys.
if [ $# -lt 3 ]; then	
	echo "Usage: $0 FILE.asc FILE keyid [keyid] [...]" 1>&2
	exit 1
fi

exitcode=0
sig_file=$1
check_file=$2
### Shift the arguments so that we can access all keys at once using $@.
shift; shift

### Either a KEY_DIR is specified or we default to the current directory.
[ ! -z "$KEY_DIR" ] || KEY_DIR=.
mkdir -p $KEY_DIR
### Create a temp keyring so that we can verify for only the specified keys.
tmp_keyring=`cd $KEY_DIR && mktemp --tmpdir=.`
[ $? -eq 0 ] || exitcode=1

### Do not use the default keyring, but use a limited, temporary one instead.
gpg_tmp="gpg --no-default-keyring --homedir $KEY_DIR --keyring $tmp_keyring"

### Import all the keys in the provided list
for keyid in $@; do
	### If the keys are available in the KEY_DIR, use these.
	if [ -f $KEY_DIR/$keyid.asc ]; then
		$gpg_tmp --import "$KEY_DIR/$keyid.asc"
		[ $? -eq 0 ] || exitcode=1
	else
		### Try to import them from the default keyring instead.
		gpg --output "$KEY_DIR/$keyid.asc" --export $keyid --armor
		if [ -f $KEY_DIR/$keyid.asc ]; then
			$gpg_tmp --import "$KEY_DIR/$keyid.asc"
			[ $? -eq 0 ] || exitcode=1
		### If all else fails, try to contact a keyserver for the key.
		else
			$gpg_tmp --recv-keys $keyid
			[ $? -eq 0 ] || exitcode=1
		fi
	fi
done
### If all keys were succesfully imported, then verify the signature.
if [ $exitcode -eq 0 ]; then
	$gpg_tmp --verify "$sig_file" "$check_file"
	[ $? -eq 0 ] || exitcode=1
fi

### Clean up the temp keyring.
rm -f "$KEY_DIR/$tmp_keyring"{,.bak}
exit $exitcode
