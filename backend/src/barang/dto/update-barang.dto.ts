import { PartialType } from '@nestjs/mapped-types';
import { CreateBarangDto } from './create-barang.dto';

// eslint-disable-next-line @typescript-eslint/no-unsafe-call
export class UpdateBarangDto extends PartialType(CreateBarangDto) {}
