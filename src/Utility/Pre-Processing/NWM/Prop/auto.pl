#! /usr/bin/perl -w

#load some functions
use File::Copy qw(copy);
use File::Copy qw(move);
use Cwd;

#dirs
#$rundir = cwd();
$script_dir="../Grid_manipulation/";

#UTM grid
system("ln -sf ../hgrid.* .");

#-----------------------fluxflag-------------------
@reg_list = glob("fluxflag/*+.reg");
$dummy_reg = $reg_list[0];
#initialize background as -1
system("$script_dir/auto_edit_prop $dummy_reg hgrid.ll -1 -1");
move("out.prop","default.prop");

my $n = 0;
foreach (@reg_list) {
    $upstream_reg = $_;
    $downstream_reg = $upstream_reg;
    $downstream_reg =~ s/\+/\-/g;
    print("$upstream_reg $downstream_reg\n");

    print("setting $downstream_reg to $n and $upstream_reg to $m\n");
    print("$script_dir/auto_edit_prop $downstream_reg hgrid.ll $n -9999\n");
    system("$script_dir/auto_edit_prop $downstream_reg hgrid.ll $n -9999");
    move("out.prop","default.prop");

    $n = $n+1;
    print("$script_dir/auto_edit_prop $upstream_reg hgrid.ll $n -9999\n");
    system("$script_dir/auto_edit_prop $upstream_reg hgrid.ll $n -9999");
    move("out.prop","default.prop");
}
move("default.prop","fluxflag.prop");

unlink("../fluxflag.prop");
copy("fluxflag.prop","../fluxflag.prop");


#-----------------------tvd-------------------
#set tvd.prop
system("$script_dir/auto_edit_prop tvd.rgn hgrid.ll 0 1");
move("out.prop","tvd.prop");
unlink("../tvd.prop");
copy("tvd.prop","../tvd.prop");


print("Done.\n")
