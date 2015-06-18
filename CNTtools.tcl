package provide CNTtools 1.0
package require inorganicbuilder
package require nanotube
package require pbctools
package require psfgen

proc genNT {molnm l n m} {
  # Create a nantube of length l with nxm structure
  nanotube -l $l -n $n -m $m
  set mymol [atomselect top all]

  # Saves nanotube with specified name
  $mymol writepsf $molnm.psf
  $mymol writepdb $molnm.pdb

}

proc pbcNT {molnm fileOut ntype} {
  ## Credit to Tom Vollman(?) from Northwestern University
  # Read in cnt that does not have periodic bonds.
  mol new [file normalize ${molnm}.psf] type psf autobonds off waitfor all
  mol addfile [file normalize ${molnm}.pdb] type pdb autobonds off waitfor all
  set molid [molinfo top]

  # Get basis vectors (a,b,c) and origin (o).
  set basis [::inorganicBuilder::findBasisVectors $molid]
  foreach {o a b c} $basis {}

  # Set cutoff distance for finding bonded atoms.
  set CNTbondCutoff 1.6
  switch $ntype {
    bnt {set scalent 1.03}
    snt {set scalent 1.25}
    default {set scalent 1.0}
  }
  set CNTbondCutoff [expr $CNTbondCutoff*$scalent]

  # Define a system box.
  set mybox [::inorganicBuilder::defineMaterialBox $o [list $a $b $c] $CNTbondCutoff]

  # This was probably intended to be used for reading in molecules with the "filebonds off" setting.
  # It currently appears to be unused.
  # set fbonds off

  # Set the periodic box to the system box, and wrap atom coordinates into the box.
  # Any atoms previously outside the box will now be in the box
  ::inorganicBuilder::setVMDPeriodicBox $mybox
  ::inorganicBuilder::transformCoordsToBox $mybox $molid

  # Recalculate bonds for selected molecule (possibly not necessary because of later command?).
  mol bondsrecalc $molid

  # Set which dimensions are periodic (x,y,z).
  set periodicIn {false false true}
  
  # Build the spring bonds.
  set relabelBonds 0
  ::inorganicBuilder::buildBonds $mybox $relabelBonds $periodicIn $molid

  # Write pdb and psf files, with just linear bonds so far.
  set fname "${fileOut}"
  set fname0 ${fname}-prebond
  set mymol [atomselect top all]
  $mymol writepsf $fname0.psf
  $mymol writepdb $fname0.pdb

  # Build the angular bonds into output file fname.
  set dihedrals 1
  ::inorganicBuilder::buildAnglesDihedrals $fname0 $fname $dihedrals

  # Reload molecule for some reason, perhaps to set beta?
  # If so, that could probably have been done earlier, so I don't currently see the point.
  mol delete $molid
  mol new [file normalize ${fname}.psf] type psf autobonds off waitfor all
  mol addfile [file normalize ${fname}.pdb] type pdb autobonds off waitfor all
  set wrappedMol [molinfo top]
  set sys [atomselect top all]
  $sys set beta 0
  $sys writepsf $molnm.psf
  $sys writepdb $molnm.pdb

  # Not sure why the below is here. Maybe I use it in the calling space.
  ::inorganicBuilder::setVMDPeriodicBox $mybox
  return $fname

}
