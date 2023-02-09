import argparse
from enum import Enum

class DataType(Enum):
    CPU = 1
    MEM = 2
    UNKNOWN = 3


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Parse smart-encoding results')
    parser.add_argument('-t', type=str, required=True, help="type: deepflow/lowcard/string")
    args = parser.parse_args()

    cpu_usage = []
    mem_usage = []
    disk_usage = []

    data_type = DataType.UNKNOWN
    with open(f"./raw_results_{args.t}.txt", 'r') as f_input:
        for line in f_input.readlines():
            if data_type is not DataType.UNKNOWN:
                if data_type is DataType.CPU:
                    arg_list = [tmp_arg for tmp_arg in line.rstrip().split(' ') if tmp_arg]
                    _cpu_usage = float(arg_list[8])
                    cpu_usage.append(_cpu_usage)
                else:
                    arg_list = [tmp_arg for tmp_arg in line.rstrip().split(' ') if tmp_arg]
                    _mem_usage = float(arg_list[8])
                    mem_usage.append(_mem_usage)
            if line.find("%CPU") != -1:
                data_type = DataType.CPU
                continue
            elif line.find("%MEM") != -1:
                data_type = DataType.MEM
                continue
            else:
                data_type = DataType.UNKNOWN

    with open(f"./raw_results_disk_{args.t}.txt", 'r') as f_input:
        start_record = False
        for line in f_input.readlines():
            if line.find("───────────") != -1:
                start_record = not start_record
                continue
            if start_record:
                arg_list = [tmp_arg for tmp_arg in line.rstrip().split(' ') if tmp_arg]
                compressed_size = float(arg_list[8])
                disk_usage.append(compressed_size)

    print(round(sum(cpu_usage) / len(cpu_usage), 2), len(cpu_usage))
    print(round(sum(mem_usage) / len(mem_usage), 2), len(mem_usage))
    print(round(sum(disk_usage) / len(disk_usage), 2), len(disk_usage))