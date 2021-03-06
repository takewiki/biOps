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


##
## TIFF read/write functions
##

#
#	Title: TIFF read/write functions
#

#	Function: readTiff
#	Open the tiff file and return an imagedata
#
#	Parameters:
#		filename - The image path
#
#	Returns:
#		An imagedata.
#
readTiff <- function(filename){
	if(!TRUE)
		stop("Sorry, libtiff not available")
	res <- .C("read_tiff_img_info", as.character(filename),
	          width=integer(1), height=integer(1), depth=integer(1),
	          ret=integer(1), PACKAGE="biOps")
	if (res$ret < 0)
		stop(if (res$ret == -1) "Cannot open file." else "Internal error")
	imgtype <- if (res$depth == 1) "grey" else "rgb"
	imgdim <- c(res$height, res$width, if (res$depth == 3) res$depth else NULL)
	res <- .C("read_tiff_img", as.character(filename),
	          image=integer(res$width * res$height * res$depth),
	          ret=integer(1), PACKAGE="biOps")
	img <- array(res$image, dim=imgdim)
	imagedata(img, type=imgtype)
}

#	Function: writeTiff
#	Save the imagedata into a tiff file
#
#	Parameters:
#		filename - The image path
#		imgdata - The image data
#
writeTiff <- function(filename, imgdata){
	if(!TRUE)
		stop("Sorry, libtiff not available")
	imgmatrix <- array(imgdata)
	depth <- if (attr(imgdata, "type") == "grey") 1 else dim(imgdata)[3]
	res <- .C("write_tiff_img", as.character(filename), image=as.integer(imgmatrix),
	          width=as.integer(dim(imgdata)[2]), height=as.integer(dim(imgdata)[1]), depth=as.integer(depth),
	          ret=integer(1), PACKAGE="biOps")
}
