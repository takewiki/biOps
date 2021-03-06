# Copyright 2007 Walter Alini, Matías Bordese

#
# This file is part of biOps.
#
#     biOps is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
#
#     biOps is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with biOps; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#


#
#	Title: Fast Fourier Transformation Filters
#


imgFFTHighPass <- function(fft_matrix, r){
	imgmatrix <- array(fft_matrix) # get linear array image representations
	depth <- if (length(dim(fft_matrix)) == 2) 1 else dim(fft_matrix)[3]
	width <- dim(fft_matrix)[2]
	height <- dim(fft_matrix)[1]

	# call the C function for image operation
	res <- .C("fft_highPass", image=as.complex(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			radius=as.integer(r), PACKAGE="biOps")

	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result	
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	img
}

imgFFTLowPass <- function(fft_matrix, r){
	imgmatrix <- array(fft_matrix) # get linear array image representations
	depth <- if (length(dim(fft_matrix)) == 2) 1 else dim(fft_matrix)[3]
	width <- dim(fft_matrix)[2]
	height <- dim(fft_matrix)[1]

	# call the C function for image operation
	res <- .C("fft_lowPass", image=as.complex(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			radius=as.integer(r), PACKAGE="biOps")

	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result	
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	img
}

imgFFTBandPass <- function(fft_matrix, r1, r2){
	imgmatrix <- array(fft_matrix) # get linear array image representations
	depth <- if (length(dim(fft_matrix)) == 2) 1 else dim(fft_matrix)[3]
	width <- dim(fft_matrix)[2]
	height <- dim(fft_matrix)[1]

	# call the C function for image operation
	res <- .C("fft_bandPass", image=as.complex(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			r1=as.integer(r1), r2=as.integer(r2), PACKAGE="biOps")

	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result	
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	img
}

imgFFTBandStop <- function(fft_matrix, r1, r2){
	imgmatrix <- array(fft_matrix) # get linear array image representations
	depth <- if (length(dim(fft_matrix)) == 2) 1 else dim(fft_matrix)[3]
	width <- dim(fft_matrix)[2]
	height <- dim(fft_matrix)[1]

	# call the C function for image operation
	res <- .C("fft_bandStop", image=as.complex(imgmatrix),
			width=as.integer(width), height=as.integer(height), depth=as.integer(depth),
			r1=as.integer(r1), r2=as.integer(r2), PACKAGE="biOps")

	imgdim <- c(height, width, if (depth == 3) depth else NULL) # dim of the result	
	img <- array(res$image, dim=imgdim) # build the matrix from linear result
	img
}

imgFFTConvolve <- function(imgdata, mask){
	if(!TRUE)
		stop("Sorry, fftw not available")

	width <- dim(imgdata)[2]
	height <- dim(imgdata)[1]

	fft_img <- imgFFT(imgdata)
	# here it could be avoided so many transformations, maybe make FFT works on matrices, so shiftings
	fft_mask <- imgFFT(imgPadding(imagedata(mask), width, height))

	c <- fft_img * fft_mask
	res <- imgFFTInv(c)
	imagedata(imgFFTiShift(res))
}
