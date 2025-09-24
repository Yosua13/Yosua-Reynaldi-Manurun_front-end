import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Kategori } from './kategori.entity';
import { CreateKategoriDto } from './dto/create-kategori.dto';

@Injectable()
export class KategoriService {
  constructor(
    @InjectRepository(Kategori)
    private kategoriRepository: Repository<Kategori>,
  ) {}

  async create(createKategoriDto: CreateKategoriDto): Promise<Kategori> {
    const kategori = this.kategoriRepository.create(createKategoriDto);
    return this.kategoriRepository.save(kategori);
  }

  async findAll(): Promise<Kategori[]> {
    return this.kategoriRepository.find();
  }
}
