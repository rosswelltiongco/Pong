
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name Pong -dir "C:/Users/Rosswell/Documents/Pong/Pong/planAhead_run_2" -part xc7a100tcsg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Rosswell/Documents/Pong/Pong/vga_sync.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Rosswell/Documents/Pong/Pong} }
set_property target_constrs_file "pong nexys4ddr.ucf" [current_fileset -constrset]
add_files [list {pong nexys4ddr.ucf}] -fileset [get_property constrset [current_run]]
link_design
