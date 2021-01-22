unit UDiskType;

interface
uses
  System.Classes, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants;
type
  diskFileType = class
  private

  public

    type
  _NTFSDBR_INFORMATION = record
    Bytes_per_secto :LARGE_INTEGER;//每扇区字节数
    Sectors_per_cluster:LARGE_INTEGER;// 每族扇区数
    ReservedSectors: Cardinal;      // 保留扇区数
    TotalSectors: Cardinal;    // 总扇区数
    PartitionType: Byte;          // 分区类型
    StartMFT: Cardinal;       // MFT起始位
    StartMFTMirr: Cardinal; // MFT备份
  end;
  NTFSDBR_INFORMATION =  _NTFSDBR_INFORMATION;
  PNTFSDBR_INFORMATION = ^_NTFSDBR_INFORMATION;
  end;

implementation

end.

