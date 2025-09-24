import { IsNotEmpty, IsString, IsNumber, IsEnum } from 'class-validator';
import { KelompokBarang } from '../kelompok-barang.enum';
import { Kategori } from '../kategori.enum';

export class CreateBarangDto {
  @IsString()
  @IsNotEmpty()
  nama_barang: string;

  @IsEnum(Kategori)
  @IsNotEmpty()
  kategori: Kategori;

  @IsEnum(KelompokBarang)
  @IsNotEmpty()
  kelompok_barang: KelompokBarang;

  @IsNumber()
  @IsNotEmpty()
  stok: number;

  @IsNumber()
  @IsNotEmpty()
  harga: number;
}
