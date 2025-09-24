import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Patch,
  Delete,
  ParseIntPipe,
  Query,
} from '@nestjs/common';
import { BarangService } from './barang.service';
import { CreateBarangDto } from './dto/create-barang.dto';
import { UpdateBarangDto } from './dto/update-barang.dto';

@Controller('barang')
export class BarangController {
  constructor(private readonly barangService: BarangService) {}

  @Post()
  create(@Body() createBarangDto: CreateBarangDto) {
    return this.barangService.create(createBarangDto);
  }

  @Get()
  findAll(@Query('search') search: string) {
    return this.barangService.findAll(search);
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.barangService.findOne(id);
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateBarangDto: UpdateBarangDto,
  ) {
    return this.barangService.update(id, updateBarangDto);
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.barangService.remove(id);
  }

  @Post('bulk-delete')
  removeBulk(@Body('ids') ids: number[]) {
    return this.barangService.removeBulk(ids);
  }
}
