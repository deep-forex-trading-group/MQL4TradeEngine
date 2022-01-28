from config_utils import gen_st_mqh_file
from dir_utils import go_to_root_dir

st_name_input = "HedgeAuto"
# go to the mql4 root dir
go_to_root_dir()

gen_st_mqh_file(st_name_input)
