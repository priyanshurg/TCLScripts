#Written by Priyanshu Ranjan Gupta
#date: Jun 20, 2023


set currentDir [pwd]
set pdbFiles [glob -nocomplain ${currentDir}/*.pdb]
set filename "Data/ReslistPerPDB.dat"
set filename2 "Data/SiteDetails.dat"
set filename3 "Data/NumAtSites.dat"
set filename4 "Data/TotalNumRes.dat"
set filename5 "Data/ReslistFull.dat"
set filename6 "Data/RoughBook.dat"
set cutoffdistance 5
set cp [open $filename w]
set cp2 [open $filename2 w]
set cp3 [open $filename3 w]
set cp4 [open $filename4 w]
set cp5 [open $filename5 w]
set cp6 [open $filename6 w]

if {[llength $pdbFiles] > 0} {
    foreach file $pdbFiles {
    mol new $file
		set last8Chars [string range $file end-7 end]
		puts $cp "/n /n Structure: $last8Chars"
		puts $cp2 "/n /n Structure: $last8Chars"
		puts $cp3 "/n /n Structure: $last8Chars"
		puts $cp4 "/n /n Structure: $last8Chars"
	#	puts $cp5 "/n /n Structure: $last8Chars"
		puts $cp6 "/n /n Structure: $last8Chars"		 
		set sites [atomselect top "resname NH4 and name N"]
		set numsites [$sites num]
		set NH4residlist [$sites get resid]
		set NH4chainlist [$sites get chain]
		set series []
		for {set i 1} {$i <= $numsites} {incr i} {
				set elementA [lindex $NH4residlist [expr $i-1]]
				set elementB [lindex $NH4chainlist [expr $i-1]]
				lappend series "${elementB} ${elementA}"
		}
		set series [getuniquenumbers $series]
		foreach NH4resid $series {
		puts "Reached loop 1"
		set chainName [lindex $NH4resid 0]
		set residNum [lindex $NH4resid 1]
		set nameofN [atomselect top "resname NH4 and resid $residNum and chain $chainName and name N"]
		set nameval [$nameofN get name]
		puts $cp6 "$nameval"
		set uniquelist []
		set uniqueValues []
		#puts $cp "Resid $residNum & Chain $chainName"
		set prot [atomselect top "(within $cutoffdistance of resid $residNum and chain $chainName and name N) and (altloc \"A\" or altloc \"\")"]
		set numbers [$prot get resid]
		set chains [$prot get chain]
		set uniquelistatthissite []
		
		foreach number $numbers chain $chains {
				lappend uniquelist2 "${chain} ${number}"
				lappend uniquelistatthissite "${chain} ${number}"
				#puts "Reached Loop 2"
		}
		set unique_residues_at_this_site [getuniquenumbers $uniquelistatthissite]
		set num_residues_at_this_site [llength $unique_residues_at_this_site] 
		puts $cp2 "Details of residues at $NH4resid :  $unique_residues_at_this_site"
		puts $cp3 "Number of residues at $NH4resid :  $num_residues_at_this_site"
		
		}
		set uniqueValues [getuniquenumbers $uniquelist2]
		set numres [llength $uniqueValues]
		puts $cp2 "Total Number of Residues: $numres" 		
		puts $cp4 "Total Number of Residues: $numres" 				
		foreach at $uniqueValues {
				puts "Reached Loop 3"
				set uniqueresid [lindex $at 1]
				set uniquechain [lindex $at 0]
				
				if {$uniqueresid < 0} {
						set protsel [atomselect top "resid \"$uniqueresid\" and chain $uniquechain"]
				} else {
						set protsel [atomselect top "resid $uniqueresid and chain $uniquechain"]
				}
				
				
				
#				set protsel [atomselect top "resid $uniqueresid and chain $uniquechain and name CA"]
		#		set protsel [atomselect top "protein and name CA and resid $numbers"]
				set protnames [$protsel get resname]
				set single_name [getuniquenumbers $protnames]
				
				if {$single_name ne "NH4"} {
        puts $cp "$at $single_name"
				puts $cp5 "$single_name"
				lappend list_of_names "$single_name"
    		}
				
						
				}
		
		mol delete all
		set uniqueValues []
		set uniquelist2 []

		}
				close $cp
				close $cp2
				close $cp3
				close $cp4				
								}

