import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Barang } from './barang.entity';
import { BarangController } from './barang.controller';
import { BarangService } from './barang.service';

@Module({
  imports: [TypeOrmModule.forFeature([Barang])],
  controllers: [BarangController],
  providers: [BarangService],
})
export class BarangModule {}
