package File::LibMagic;

use 5.008;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use File::LibMagic ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	magic_buffer magic_file
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&File::LibMagic::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('File::LibMagic', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

File::LibMagic - Perlwrapper for libmagic

=head1 SYNOPSIS

  use File::LibMagic qw/magic_buffer magic_file/;

  print magic_buffer("Hello World\n"),"\n";
  # returns "ASCII text"

  print magic_file("/bin/ls"),"\n";
  # returns "ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV)"
  # on my system

=head1 ABSTRACT

The C<File::LibMagic> is a simple perl interface to libmagic from
the file-4.x package from Christos Zoulas (ftp://ftp.astron.com/pub/file/)

=head1 DESCRIPTION

The C<File::LibMagic> is a simple perlinterface to libmagic from
the file-4.x package from Christos Zoulas (ftp://ftp.astron.com/pub/file/).

=head2 EXPORT

None by default.

=head1 AUTHOR

Andreas Fitzner E<lt>fitzner@informatik.hu-berlin.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by Andreas Fitzner

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
