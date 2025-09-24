import { IsNotEmpty, IsString, IsNumber, IsEnum } from 'class-validator';
import { KelompokBarang } from '../kelompok-barang.enum';

export class CreateBarangDto {
  @IsString()
  @IsNotEmpty()
  nama_barang: string;

  @IsNumber()
  @IsNotEmpty()
  kategori_id: number;

  @IsNumber()
  @IsNotEmpty()
  stok: number;

  @IsEnum(KelompokBarang)
  @IsNotEmpty()
  kelompok_barang: KelompokBarang;

  @IsNumber()
  @IsNotEmpty()
  harga: number;
}
