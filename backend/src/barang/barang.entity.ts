import { Kategori } from '../kategori/kategori.entity';
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { KelompokBarang } from './kelompok-barang.enum';

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
    enum: KelompokBarang,
    default: KelompokBarang.LAINNYA,
  })
  kelompok_barang: KelompokBarang;

  @Column()
  harga: number;

  @Column()
  kategori_id: number;

  @ManyToOne(() => Kategori, (kategori) => kategori.barang)
  @JoinColumn({ name: 'kategori_id' })
  kategori: Kategori;
}
