--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

-- Create a viewer
local viewer = View.create()

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  -- Files on disk are stored by camera name, list the names here
  local cameras = {'cam_14340525', 'cam_14425986', 'cam_14135893'}

  ---------------------------------------------------------------------------
  -- To create camera models at the appropriate positions we need
  -- to know the offset between each. These variables contain that
  -- information. In a more typical use case the cameras should all
  -- be calibrated using the same checkerboard and one of the
  -- functions found in Image.Calibration.Pose.
  local encoderResolution = 0.02
  local encoderValues = {138600, 139260, 139920, 140580, 141240, 141900, 142560, 143220, 143880, 144540, 145200, 145860, 146520}
  local direction = {0.99818713673244, 0.06014000366606, 0.0023706583345014}
  ---------------------------------------------------------------------------

  -- Get the camera model corresponding to a certain device and offset
  local function getCameraModel(index, position)
    local model = Object.load('resources/' .. cameras[index] .. '.json', 'JSON')
    local offset = (encoderValues[position] - encoderValues[1]) * encoderResolution
    model = Image.Calibration.CameraModel.translate(model, direction, offset)
    return model
  end

  -- Get the image corresponding to a certain device and offset
  local function getImage(index, position)
    local filepath = string.format('resources/%s/%d.png', cameras[index], position - 1)
    local image = Image.load(filepath)
    return image
  end

  -- Create a stitcher object and populate it with cameras and images
  local stitcher = Image.Stitching.StaticScene.create()
  local cameraIndex = {1, 2, 3}
  local exposureIndex = {4, 6, 10}
  for e = 1, #exposureIndex do
    for c = 1, #cameraIndex do
      local id = stitcher:addCamera(getCameraModel(c, e))
      stitcher:setImage(getImage(c, e), id)
    end
  end

  -- Setup plane estimation (default options)
  stitcher:setPlaneEstimation(true)
  stitcher:setPlaneEstimationAngle(0.5)             -- Deviation by max 0.5 radians from calibration plane.
  stitcher:setPlaneEstimationDownsampleFactor(2.0)  -- Use at most a resolution of width/2 x height/2 of the input.
  stitcher:setPlaneEstimationThreshold(1.0)         -- Large values gives better convergence, smaller are more precise.

  -- Setup shading correction (default options)
  stitcher:setShadingCorrection('ON')                 -- Select to calculate and apply shading correction.
  stitcher:setShadingCorrectionDownsampleFactor(2.0)  -- Perform shading correction calculation on a subsampled image.

  -- Perform an auto adjusted plane stitch
  local planeGuess = Shape3D.createPlane(0, 0, 1.0, 60.0) -- A quite poor guess, object is really at 40 mm height
  local image, plane = stitcher:stitch(planeGuess)        -- Do stitch with automatic tuning

  -- Display results
  if image and plane then
    viewer:view(image)
    print(plane:toString())
    print('Stitching successful')
  else
    print('Stitching failed')
  end

  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
