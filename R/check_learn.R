##########################
#' Visual checks for the output of tuneLearn()
#' 
#' @description Provides some visual plots showing how the calibration criterion and the effective degrees of 
#'              freedom of each smooth component vary with the learning rate.  
#'  
#' @param obj the output of a call to \code{tuneLearn}.
#' @param sel this function produces two plots, set this parameter to 1 to plot only the first, 
#'            to 2 to plot only the second or leave it to 1:2 to plot both.
#' @param ... currently not used, here only for compatibility reasons.
#' @return It produces several plots. 
#' @details The first plot shows how the calibrations loss, which we are trying to minimize, varies with the 
#'          log learning rate. This function should look quite smooth, if it doesn't then try to increase
#'          \code{err} or \code{control$K} (the number of bootstrap samples) in the original call to 
#'          \code{tuneLearn}. The second plot shows how the effective degrees of freedom of each smooth term
#'          vary with log(sigma). Generally as log(sigma) increases the complexity of the fit decreases, hence
#'          the slope is negative.
#' @author Matteo Fasiolo <matteo.fasiolo@@gmail.com>. 
#' @references Fasiolo, M., Wood, S.N., Zaffran, M., Nedellec, R. and Goude, Y., 2020. 
#'             Fast calibrated additive quantile regression. 
#'             Journal of the American Statistical Association (to appear).
#'             \doi{10.1080/01621459.2020.1725521}.
#' @examples
#' library(qgam)
#' set.seed(525)
#' dat <- gamSim(1, n=200)
#' b <- tuneLearn(lsig = seq(-0.5, 1, length.out = 10), 
#'                y~s(x0)+s(x1)+s(x2)+s(x3), 
#'                data=dat, qu = 0.5)
#' check(b) 
#'
check.learn <- function(obj, sel = 1:2, ...)
{  
  sig <- as.numeric( names( obj$loss ) )
  
  if( 1 %in% sel ){
  # readline(prompt = "Press <Enter> to see the next plot...")
  plot(sig, obj$loss, type = "b", ylab = "Calibration Loss", xlab = expression("log(" * sigma * ")"))
  rug(sig[obj$convProb], side = 3, col = 2, lwd = 2)
  }
  
  if( !is.null(obj$edf) && 2 %in% sel )
  {
    # readline(prompt = "Press <Enter> to see the next plot...")
    nc <- ncol(obj$edf)
    matplot(obj$edf[ , 1], obj$edf[ , 2:nc], type = 'b', ylab = "Penalized EDF", xlab = expression("log(" * sigma * ")"), 
            pch = 1:nc, col = 1:nc)
    legend("topright", colnames(obj$edf)[2:nc], pch = 1:nc, col = 1:nc, bg="transparent")
    rug(sig[obj$convProb], side = 3, col = 2, lwd = 2)
  }
  
  return( invisible(NULL) )
}
