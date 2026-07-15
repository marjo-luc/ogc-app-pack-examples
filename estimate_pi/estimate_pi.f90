! Estimate pi by numerically integrating 4 / (1 + x^2) over [0, 1]
! using the midpoint rule. The exact value of that integral is pi.
program estimate_pi
   implicit none

   integer :: n, i, nargs, ios
   real(kind=8) :: h, x, s, pi_est, pi_ref, err
   character(len=256) :: arg, val, output_file, output_dir, output_path

   ! Defaults (overridden by command-line arguments).
   n = 1000000
   output_file = "pi.txt"
   output_dir = "output"

   ! Parse "--intervals N" and "--output_file FILE".
   nargs = command_argument_count()
   i = 1
   do while (i <= nargs)
      call get_command_argument(i, arg)
      select case (trim(arg))
      case ("--intervals")
         i = i + 1
         call get_command_argument(i, val)
         read (val, *, iostat=ios) n
         if (ios /= 0 .or. n < 1) then
            write (*, *) "Invalid value for --intervals: ", trim(val)
            stop 1
         end if
      case ("--output_file")
         i = i + 1
         call get_command_argument(i, output_file)
      case default
         write (*, *) "Unknown argument: ", trim(arg)
         stop 1
      end select
      i = i + 1
   end do

   ! Midpoint rule: sum f(x_i) over subinterval midpoints, times width h.
   h = 1.0d0/real(n, kind=8)
   s = 0.0d0
   do i = 1, n
      x = (real(i, kind=8) - 0.5d0)*h
      s = s + 4.0d0/(1.0d0 + x*x)
   end do
   pi_est = s*h

   pi_ref = 4.0d0*atan(1.0d0)
   err = abs(pi_est - pi_ref)

   ! Write the result into the output directory so the CWL workflow can
   ! collect it as a Directory output.
   call execute_command_line("mkdir -p "//trim(output_dir))
   output_path = trim(output_dir)//"/"//trim(output_file)

   open (unit=10, file=trim(output_path), status="replace", action="write")
   write (10, '(A, I0)') "intervals = ", n
   write (10, '(A, F0.15)') "pi_estimate = ", pi_est
   write (10, '(A, ES12.5)') "abs_error = ", err
   close (10)

   write (*, '(A, F0.15, A, A)') "Estimated pi = ", pi_est, &
      " -> written to ", trim(output_path)
end program estimate_pi
