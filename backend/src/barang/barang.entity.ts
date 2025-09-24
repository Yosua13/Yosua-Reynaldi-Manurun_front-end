import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { KelompokBarang } from './kelompok-barang.enum';
import { Kategori } from './kategori.enum';

@Entity('barang')
export class Barang {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  nama_barang: string;

  @Column()
  stok: number;

  @Column({
    type: 'enum',
    enum: Kategori,
  })
  kategori: Kategori;

  @Column({
    type: 'enum',
    enum: KelompokBarang,
  })
  kelompok_barang: KelompokBarang;

  @Column()
  harga: number;
}
