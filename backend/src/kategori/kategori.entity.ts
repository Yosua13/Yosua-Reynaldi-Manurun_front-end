import { Barang } from 'src/barang/barang.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';

@Entity('kategori')
export class Kategori {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  nama_kategori: string;

  @OneToMany(() => Barang, (barang) => barang.kategori)
  barang: Barang[];
}
