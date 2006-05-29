# Parameter file for simulating a single component vesicle at fixed
# box size and temperature.
#
#
# To run this file use $ESPRESSO_SOURCE/$PLATFORM/Espresso ./scripts/main.tcl sphere.tcl
#

# For more information about the simulation model on which this
# simulation is based see the following reference
# 
#  Cooke, I. R., Kremer, K. and Deserno, M.(2005): Tuneable, generic
# model for fluid bilayer membranes. Phys. Rev. E. 72 - 011506 
#

::mmsg::send [namespace current] "loading parameter file .. " nonewline
flush stdout



# Specify the name of the job <ident> the location of forcetables and
# the output and scripts directories
set ident "sphere"
set tabledir "./forcetables/"
set outputdir "./$ident/"
set topofile "$ident.top"

# Specify how we want to use vmd for visualization allowable values
# are "interactive" "offline" "none".  interactive rarely works
set use_vmd "offline"


# --- Specify a global key for molecule types -----#

# In this line we specify the details of all molecule types in the
# system.  In this example molecule type 0 is assigned to be a lipid.
# The atom types in this lipid are 0 1 and 1 respectively and the
# bonding interactions are type 0 for short bonds and type 1 for long
# bonds.
set moltypes [list { 0 lipid { 0 1 1 } { 0 1 } } ]

# --- Specify the system geometry and composition ----#
# Set the geometry to sphere
set geometry { geometry "sphere -shuffle" }

set n_molslist { n_molslist {  { 0 1000 } } }

# Now bundle the above info into a list
lappend spherespec $geometry
lappend spherespec $n_molslist


# Now group the bilayerspec with other specs into a list of such
# systems (we can have multiple systems if we like each with different
# composition of molecule types
lappend system_specs $spherespec


set setbox_l  { 40.0 40.0 40.0 }

# Warmup parameters
#----------------------------------------------------------#
set warm_time_step 0.002

set free_warmsteps 100
set free_warmtimes 1 

# ------ Integration parameters -----------------#
set main_time_step 0.01
set verlet_skin 0.4
set langevin_gamma 1.0
set systemtemp 1.1

# The number of steps to integrate with each call to integrate
set int_steps   100
# The number of times to call integrate
set int_n_times 100
# Write a configuration file every <write_frequency> calls to
# integrate
set write_frequency 10
# Write results to analysis files every <analysis_write_frequency>
# calls to integrate
set analysis_write_frequency 1

# Bonded and bending Potentials
#----------------------------------------------------------#
lappend bonded_parms [list 0 FENE 30 1.5 ]
lappend bonded_parms [list 1 harmonic 10.0 4.0 ]


# Non Bonded Potentials 
#----------------------------------------------------------#
lappend nb_interactions [list 0 0 tabulated 9_095_11.tab ]
lappend nb_interactions [list 0 1 tabulated 9_095_11.tab ]
lappend nb_interactions [list 1 1 tabulated n9_c160_22.tab ]

lappend tablenames 9_095_11.tab
lappend tablenames n9_c160_22.tab 


# Analysis Parameters
#----------------------------------------------------------# 

# Use these flags to specify which observables to calculate during the
# simulation.  Values are calculated after every call to the espresso
# integrate command and written to files like
# time_vs_parametername. See the module ::std_analysis for more
# details

# Since in this case we have a sphere and no bilayer we avoid any
# analysis routines which rely on a gridded bilayer because these will
# exit when they find a large hole in the bilayer.
#lappend analysis_flags "flipflop"
#lappend analysis_flags "fluctuations"

lappend analysis_flags pressure
lappend analysis_flags pik1
lappend analysis_flags boxl
lappend analysis_flags energy
lappend analysis_flags "density_profile -beadtypes \{ 0 1 \} -r 8.0 "


::mmsg::send [namespace current] "done"

















