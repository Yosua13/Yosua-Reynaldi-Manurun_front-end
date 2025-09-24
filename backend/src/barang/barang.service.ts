import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository, Like } from 'typeorm';
import { Barang } from './barang.entity';
import { CreateBarangDto } from './dto/create-barang.dto';
import { UpdateBarangDto } from './dto/update-barang.dto';

@Injectable()
export class BarangService {
  constructor(
    @InjectRepository(Barang)
    private barangRepository: Repository<Barang>,
  ) {}

  async create(createBarangDto: CreateBarangDto): Promise<Barang> {
    const barang = this.barangRepository.create(createBarangDto);
    return this.barangRepository.save(barang);
  }

  async findAll(search?: string): Promise<Barang[]> {
    if (search) {
      return this.barangRepository.find({
        where: { nama_barang: Like(`%${search}%`) },
      });
    }
    return this.barangRepository.find();
  }

  async findOne(id: number): Promise<Barang> {
    const barang = await this.barangRepository.findOne({
      where: { id },
    });
    if (!barang) {
      throw new NotFoundException(`Barang dengan ID #${id} tidak ditemukan`);
    }
    return barang;
  }

  async update(id: number, updateBarangDto: UpdateBarangDto): Promise<Barang> {
    const barang = await this.barangRepository.preload({
      id: id,
      ...updateBarangDto,
    });
    if (!barang) {
      throw new NotFoundException(`Barang dengan ID #${id} tidak ditemukan`);
    }
    return this.barangRepository.save(barang);
  }

  async remove(id: number): Promise<{ message: string }> {
    const result = await this.barangRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Barang dengan ID #${id} tidak ditemukan`);
    }
    return { message: `Barang dengan ID #${id} berhasil dihapus.` };
  }

  async removeBulk(ids: number[]): Promise<{ message: string }> {
    const result = await this.barangRepository.delete({ id: In(ids) });
    if (result.affected === 0) {
      throw new NotFoundException(
        `Tidak ada barang yang cocok dengan ID yang diberikan.`,
      );
    }
    return { message: `${result.affected} barang berhasil dihapus.` };
  }
}
